/*
Right Vote - A web app for election prediction and manifesto comparison with machine learning and NLP.
Nilakna Warushavithana, September 2024
*/

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';

class CompareScreenGenerator extends StatefulWidget {
  final bool scrollToComparison;

  const CompareScreenGenerator({super.key, this.scrollToComparison = false});

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
    {
      "Candidate3": {
        "Economy": "2-Regulation-focused",
        "Healthcare": "2-Private healthcare",
        "Education": "2 -Voucher system",
      },
    },
  ];

  late var _comparisonCategories =
      _comparisonData[0].values.toList()[0].keys.toList();
  late var _comparisonNames = [
    _comparisonData[0],
    _comparisonData[1],
    _comparisonData[2]
  ].map((e) => e.keys.toList()[0]).toList();
  late var _comparisonContent = [
    _comparisonData[0].values.toList()[0].values.toList(),
    _comparisonData[1].values.toList()[0].values.toList(),
    _comparisonData[2].values.toList()[0].values.toList(),
  ];

  final _comparisonBetter = [
    ["Candidate1", "Candidate2", "Candidate1"],
    ["Candidate2", "Candidate1", "Candidate2"],
  ];

  /*the following functions are used for larger group of candidates, to compare two at a time. 
  current app shows all major 3 candidates side by side*/

  // String? _selectedCandidate1;
  // String? _selectedCandidate2;

  final String apiUrl =
      'YOUR_FIREBASE_FUNCTION_URL_HERE'; // Replace with your Firebase function URL

  final String apiUrl_winpredict =
      'YOUR_FIREBASE_FUNCTION_URL_HERE'; // Replace with your Firebase function URL

  double anuraWinPercentage = 39.57;
  double ranilWinPercentage = 21.36;
  double sajithWinPercentage = 32.12;
  bool isLoading = true;

  // final ScrollController _scrollController = ScrollController();
  // final GlobalKey comparisonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _selectedCandidate1 = _comparisonNames[0];
    // _selectedCandidate2 = _comparisonNames[1];
    // _fetchWinPrediction(); //for a real time win prediction
    // _fetchComparisonData(
    //     ["Candidate1", "Candidate2"]); // Pass candidate IDs or names
    // Scroll to the comparison area if the parameter is true
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.scrollToComparison) {
    //     _scrollToComparison();
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // Future<void> _fetchWinPrediction() async {
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl + '/win-prediction'));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       setState(() {
  //         anuraWinPercentage = responseData['anura'] ?? 0.0;
  //         ranilWinPercentage = responseData['ranil'] ?? 0.0;
  //         sajithWinPercentage = responseData['sajith'] ?? 0.0;
  //         isLoading = false;
  //       });
  //     } else {
  //       print('Error fetching prediction: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Network error: $error');
  //   }
  // }

  void _fetchComparisonData(List<String> candidates) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl + '/compare'),
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

  // void _scrollToComparison() {
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent, // Scroll to the end
  //     duration: Duration(seconds: 1),
  //     curve: Curves.easeInOut,
  //   );
  // }

  Widget _buildComparisonTable() {
    if (_comparisonData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(_comparisonNames[0],
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(_comparisonNames[1],
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(_comparisonNames[2],
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Better',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(
              (_comparisonCategories.length),
              (index) => DataRow(cells: [
                    DataCell(Text(_comparisonCategories[index])),
                    DataCell(Text(_comparisonContent[0][index])),
                    DataCell(Text(_comparisonContent[1][index])),
                    DataCell(Text(_comparisonContent[2][index])),
                    DataCell(Text(_comparisonBetter[0][index])),
                  ])),
        ));
  }

  Widget _firstVoteChart() {
    //remove hardcode these to get actual data
    double othersWinPercentage =
        100 - (anuraWinPercentage + ranilWinPercentage + sajithWinPercentage);

    Map<String, double> dataMap = {
      "Anura": anuraWinPercentage,
      "Sajith": sajithWinPercentage,
      "Ranil": ranilWinPercentage,
      "Others": othersWinPercentage,
    };

    final colorList = <Color>[
      Colors.pinkAccent,
      Colors.green,
      Colors.yellow,
      Colors.grey,
    ];

    return SizedBox(
        height: 200, // Set height for the pie chart
        child: PieChart(
          dataMap: dataMap,
          // animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          // chartRadius: MediaQuery.of(context).size.width / 4,
          colorList: colorList,
          initialAngleInDegree: -90,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          // centerText: "1st Vote",
          legendOptions: const LegendOptions(
            // showLegendsInRow: true,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            // legendTextStyle: TextStyle(
            //   fontWeight: FontWeight.bold,
            // ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
          ),
        ));
  }

  Widget _secondVotesChart() {
    //remove hardcode these to get actual data
    double othersWinPercentage =
        100 - (anuraWinPercentage + ranilWinPercentage + sajithWinPercentage);

    Map<String, double> dataMap = {
      "Anura": 44.27, // put the actual value here
      "Sajith": 39.59,
      // "Ranil": ranils,
      "Others": othersWinPercentage,
    };

    final colorList = <Color>[
      Colors.pinkAccent,
      // Colors.yellow,
      Colors.green,
      Colors.grey,
    ];

    return SizedBox(
        height: 200, // Set height for the pie chart
        child: PieChart(
          dataMap: dataMap,
          // animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          // chartRadius: MediaQuery.of(context).size.width / 4,
          colorList: colorList,
          initialAngleInDegree: -90,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          // centerText: "1st + 2nd vote",
          legendOptions: const LegendOptions(
            // showLegendsInRow: true,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              // backgroundColor: Colors.white,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
          ),
        ));
  }

  // the following function is used for larger group of candidates, to compare two at a time.

  // Widget _selectCandidateButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       DropdownButton<String>(
  //         value: _selectedCandidate1,
  //         items: _comparisonNames
  //             .map((e) => DropdownMenuItem(
  //                   child: Text(e),
  //                   value: e,
  //                 ))
  //             .toList(),
  //         onChanged: (value) {
  //           setState(() {
  //             _selectedCandidate1 = value;
  //             _fetchComparisonData([value!, _selectedCandidate2!]);
  //           });
  //         },
  //       ),
  //       DropdownButton<String>(
  //         value: _selectedCandidate2,
  //         items: _comparisonNames
  //             .map((e) => DropdownMenuItem(
  //                   child: Text(e),
  //                   value: e,
  //                 ))
  //             .toList(),
  //         onChanged: (value) {
  //           setState(() {
  //             _selectedCandidate2 = value;
  //             _fetchComparisonData([_selectedCandidate1!, value!]);
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTeamInfo() {
    return Container(
      width: double.infinity,
      color: Colors.lightBlue[50],
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Text('Developed by LLMinators', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16.0),
          Text(
              '#TeamLLMinators #AIChallenge #IEEEChallengeSphere #MachineLearning',
              textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          Text(
            'This app is created for educational purposes only.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }

  Widget _firstVoteBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(255, 255, 255, 0.4),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _firstVoteChart(),
          Text(
            'Based on First Vote',
            style: TextStyle(
              fontSize: 16.0,
              // fontWeight: FontWeight.bold
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _secondVoteBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(255, 255, 255, 0.4),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          _secondVotesChart(),
          Text(
            'Based on First Vote',
            style: TextStyle(
              fontSize: 16.0,
              // fontWeight: FontWeight.bold
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _comparisonTableBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(225, 245, 254, 0.75),
      ),
      alignment: Alignment.center,
      child: _buildComparisonTable(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Image.asset(
          "assets/bgimg.jpg", // Ensure this path is correct
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        ),
        SingleChildScrollView(
          // controller: _scrollController, // Scroll controller for scrolling to the comparison area. removed because of the change in design
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25.0),
                Text(
                  'Win Prediction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                    children: [_firstVoteBox(), _secondVoteBox()],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly),
                SizedBox(height: 25.0),
                Text(
                  'Manifesto Comparison',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0), // Add some spacing
                // _selectCandidateButton(), /// to choose candidates from if manifestos trained for all the candidates
                // SizedBox(height: 16.0),
                _comparisonTableBox(),
                SizedBox(height: 100.0),
                _buildTeamInfo(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
