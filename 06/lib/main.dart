import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier;
  final ValueNotifier<List<String>> columnNamesNotifier;
  final ValueNotifier<List<String>> propertyNamesNotifier;

  DataService()
      : tableStateNotifier = ValueNotifier([
          {"name": "Brazil", "style": "Samba", "ping": "10"},
          {"name": "USA", "style": "Rock", "ping": "3"},
          {"name": "New Zealand", "style": "Blues", "ping": "8"}
        ]),
        columnNamesNotifier = ValueNotifier(["Name", "Musical Style", "Ping Note"]),
        propertyNamesNotifier = ValueNotifier(["name", "style", "ping"]);

  void loadData(index) {
    final List<Function> functions = [
      loadCoffees,
      loadBeers,
      loadCountries,
    ];
    functions[index]();
  }

  void loadBeers() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premium", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];
    columnNamesNotifier.value = ["Name", "Style", "IBU"];
    propertyNamesNotifier.value = ["name", "style", "ibu"];
  }

  void loadCoffees() {
    tableStateNotifier.value = [
      {"name": "Santa Clara", "quality": "Reasonable", "note": "9"},
      {"name": "Marata", "quality": "Terrible", "note": "2"},
      {"name": "Serido", "quality": "Terrible", "note": "0"},
      {"name": "Pilão", "quality": "Reasonable", "note": "9"},
    ];
    columnNamesNotifier.value = ["Name", "Quality", "Personal Note"];
    propertyNamesNotifier.value = ["name", "quality", "note"];
  }

  void loadCountries() {
    tableStateNotifier.value = [
      {"name": "Brazil", "style": "Samba", "ping": "10"},
      {"name": "USA", "style": "Rock", "ping": "3"},
      {"name": "New Zealand", "style": "Blues", "ping": "8"}
    ];
    columnNamesNotifier.value = ["Name", "Musical Style", "Ping Note"];
    propertyNamesNotifier.value = ["name", "style", "ping"];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Tips"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                  jsonObjects: value,
                );
              }),
          bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.loadData),
        ));
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;

          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Coffees",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Beers", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Countries", icon: Icon(Icons.flag_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  DataTableWidget({required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    final columnNames = dataService.columnNamesNotifier.value;
    final propertyNames = dataService.propertyNamesNotifier.value;
    return DataTable(
      columns: columnNames
          .map((name) => DataColumn(
              label: Expanded(
                  child: Text(name,
                      style: const TextStyle(fontStyle: FontStyle.italic)))))
          .toList(),
      rows: jsonObjects
          .map((obj) => DataRow(
              cells: propertyNames
                  .map((propName) => DataCell(Text(obj[propName])))
                  .toList()))
          .toList(),
    );
  }
}