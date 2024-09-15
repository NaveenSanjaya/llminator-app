import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompareScreenGenerator extends StatefulWidget {
  const CompareScreenGenerator({super.key});

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreenGenerator> {
  final List<Map<String, dynamic>> _comparisonData = [
    {
      "Candidate1": {
        "Economy": "Pro-market policies",
        "Healthcare": "Universal healthcare",
        "Education": "Increase funding for schools",
      },
    },
    {
      "Candidate2": {
        "Economy": "Regulation-focused",
        "Healthcare": "Private healthcare",
        "Education": "Voucher system",
      },
    },
  ];

  late var _comparisonCategories =
      _comparisonData[0].values.toList()[0].keys.toList();
  late var _comparisonNames = [_comparisonData[0], _comparisonData[1]]
      .map((e) => e.keys.toList()[0])
      .toList();
  late var _comparisonContent = [
    _comparisonData[0].values.toList()[0].values.toList(),
    _comparisonData[1].values.toList()[0].values.toList()
  ];

  final _comparisonBetter = [
    ["Candidate1", "Candidate2", "Candidate1"],
    ["Candidate2", "Candidate1", "Candidate2"],
  ];

  String? _selectedCandidate1;
  String? _selectedCandidate2;

  final String apiUrl =
      'YOUR_FIREBASE_FUNCTION_URL_HERE'; // Replace with your Firebase function URL

  @override
  void initState() {
    super.initState();
    _selectedCandidate1 = _comparisonNames[0];
    _selectedCandidate2 = _comparisonNames[1];
    // _fetchComparisonData(
    //     ["Candidate1", "Candidate2"]); // Pass candidate IDs or names
  }

  void _fetchComparisonData(List<String> candidates) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/compare'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"candidates": candidates}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _comparisonData.clear();
          _comparisonData.addAll(responseData['comparison']);
          _updateComparisonInfo();
        });
      } else {
        // Handle error
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network error
      print('Network error: $error');
    }
  }

  void _updateComparisonInfo() {
    // Update the categories and candidate names based on the new comparison data
    _comparisonCategories = _comparisonData[0].values.toList()[0].keys.toList();
    _comparisonNames = [_comparisonData[0], _comparisonData[1]]
        .map((e) => e.keys.toList()[0])
        .toList();
    _comparisonContent = [
      _comparisonData[0].values.toList()[0].values.toList(),
      _comparisonData[1].values.toList()[0].values.toList()
    ];
  }

  Widget _buildComparisonTable() {
    if (_comparisonData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Category')),
            DataColumn(label: Text(_comparisonNames[0])),
            DataColumn(label: Text(_comparisonNames[1])),
            const DataColumn(label: Text('Better')),
          ],
          rows: List<DataRow>.generate(
              (_comparisonCategories.length),
              (index) => DataRow(cells: [
                    DataCell(Text(_comparisonCategories[index])),
                    DataCell(Text(_comparisonContent[0][index])),
                    DataCell(Text(_comparisonContent[1][index])),
                    DataCell(Text(_comparisonBetter[0][index])),
                  ])),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Candidates'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _selectedCandidate1,
                  items: _comparisonNames
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCandidate1 = value;
                      _fetchComparisonData([value!, _selectedCandidate2!]);
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _selectedCandidate2,
                  items: _comparisonNames
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCandidate2 = value;
                      _fetchComparisonData([_selectedCandidate1!, value!]);
                    });
                  },
                ),
              ],
            ),
            Expanded(child: _buildComparisonTable()),
          ],
        ),
      ),
    );
  }
}
