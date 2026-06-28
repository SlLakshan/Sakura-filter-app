import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakura Filter Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FilterSearchPage(),
    );
  }
}

class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({super.key});
  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  List<List<dynamic>> _data = [];
  List<List<dynamic>> _filteredData = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString('sakura_filters.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
      _filteredData = listData;
    });
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data.where((row) => row[0].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sakura Filter Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Search Part No', border: OutlineInputBorder()),
              onChanged: _filterData,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_filteredData[index][0].toString()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
