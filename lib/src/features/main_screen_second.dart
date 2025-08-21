import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _zipSearchController = TextEditingController();
  Future<String>? _city;

  @override
  void initState() {
    super.initState();
    _city = _loadStart(_zipSearchController.text);
  }

  void _search() {
    setState(() {
      _city = getCityFromZip(_zipSearchController.text);
    });
  }

  Future<String> _loadStart(String zip) async {
    if (zip == '') {
      return '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //SafeArea damit das eingabefled auch nutzbar ist....
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              spacing: 32,
              children: [
                TextFormField(
                  controller: _zipSearchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Postleitzahl",
                  ),
                ),
                OutlinedButton(
                  onPressed: _search,
                  child: const Text("Suche"),
                ),
                FutureBuilder<String>(
                  future: _city,
                  builder: (coontext, snapshot) {
                    //Laden
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                            'Suche Daten...',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      );
                    }
                    //Fehler beim laden
                    if (snapshot.hasError) {
                      return Text(
                        'Fehler bei der Ausführung...',
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    }
                    //Daten erfolgreich geladen
                    if (snapshot.hasData && snapshot.data != '') {
                      return Text(
                        '${snapshot.data}',
                        style: Theme.of(context).textTheme.labelLarge,
                      );
                    }
                    return Text(
                      'Ergebnis: Noch keine PLZ gesucht',
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _zipSearchController.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}
