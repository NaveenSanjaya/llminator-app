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
      "Anura": {
        "Economy": "Pro-market policies",
        "Healthcare": "Universal healthcare",
        "Education": "Increase funding for schools",
      },
    },
    {
      "Sajith": {
        "Economy": "Regulation-focused",
        "Healthcare": "Private healthcare",
        "Education": "Voucher system",
      },
    },
    {
      "Ranil": {
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

  final _themeTopics = <List>[
    [
      'Public and Micro Finance',
      'Industries',
      'Technology',
      'Legal Reform',
      'Housing and Construction',
      'Trade, Business, and SMEs',
      'Public Administration'
    ],
    [
      'Industries',
      'Housing and Construction',
      'Technology',
      'Land',
      'Transportation',
      'Power and Energy',
      'Justice System',
      'Science and Research',
      'Mass Media',
      'Public and Micro Finance',
      'Water Supply',
      'Ports and Shipping',
      'Environmental Conservation and Mitigating Pollution',
      'Urban Development',
      'Legal Reform',
      'Aviation',
      'Labour Welfare and Regulation',
      'Disaster Management',
      'Public Administration'
    ],
    [
      'Child Development and Women\'s Affairs',
      'Labour Welfare and Regulation',
      'Community Support',
      'Public and Micro Finance',
      'Healthcare',
      'Transportation',
      'National Security',
      'Housing and Construction',
      'Foreign Affairs',
      'Public Administration',
      'Justice System',
      'Urban Development'
    ],
    [
      'Sports Affairs',
      'Cultural and Religious Affairs',
      'Environmental Conservation and Mitigating Pollution',
      'Public and Micro Finance',
      'Foreign Employment',
      'Parliament, Provincial Councils and Local Government',
      'Mass Media',
      'Foreign Affairs',
      'Primary and Secondary Education',
      'Public Administration',
      'Water Supply',
      'Trade, Business, and SMEs',
      'Healthcare',
      'SOE Reform'
    ],
    [
      'Livestock',
      'Plantation Industries',
      'Fisheries and Aquatic Resources',
      'Trade, Business, and SMEs',
      'Traditional and Modern Agriculture',
      'Technology',
      'Water Supply',
      'Labour Welfare and Regulation',
      'Public and Micro Finance',
      'Land'
    ],
    [
      'SOE Reform',
      'Parliament, Provincial Councils and Local Government',
      'Public Administration',
      'Land',
      'Public and Micro Finance',
      'Technology',
      'Youth Affairs and Skills',
      'Legal Reform',
      'Foreign Affairs',
      'Power and Energy'
    ],
    [
      'Public and Micro Finance',
      'Tourism',
      'Economic and Investment Zones',
      'Trade, Business, and SMEs'
    ],
    [
      'Legal Reform',
      'Justice System',
      'National Security',
      'Legal Enforcement',
      'Police',
      'Power and Energy',
      'Parliament, Provincial Councils and Local Government',
      'Cultural and Religious Affairs',
      'Child Development and Women\'s Affairs',
      'Healthcare',
      'Rehabilitation and Prisons Reform'
    ],
    [
      'Public Administration',
      'Labour Welfare and Regulation',
      'Youth Affairs and Skills',
      'Foreign Employment',
      'Child Development and Women\'s Affairs',
      'Community Support'
    ],
    [
      'Vocational Development',
      'Higher Education',
      'Primary and Secondary Education',
      'Youth Affairs and Skills',
      'Child Development and Women\'s Affairs',
      'Labour Welfare and Regulation',
      'Healthcare',
      'Technology',
      'Mass Media',
      'Science and Research'
    ],
    [
      'Vocational Development',
      'Higher Education',
      'Primary and Secondary Education',
      'Youth Affairs and Skills',
      'Child Development and Women\'s Affairs',
      'Labour Welfare and Regulation',
      'Healthcare',
      'Technology',
      'Mass Media',
      ' Science and Research'
    ],
    [
      'Legal Enforcement',
      'Justice System',
      'Public Administration',
      'Legal Reform',
      'Public and Micro Finance'
    ],
    [
      'Healthcare',
      'Medical Staff and Hospitals',
      'Medicine',
      'Indigenous Medicine',
      'Child Development and Women\'s Affairs'
    ],
    ['Public and Micro Finance', 'Public Administration'],
    [
      'Legal Enforcement',
      'Cultural and Religious Affairs',
      'Land',
      'Community Support'
    ],
  ];

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
              'Theme',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(_comparisonNames[0] + ' \%',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(_comparisonNames[1] + ' \%',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(_comparisonNames[2] + ' \%',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Focused Areas',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(
              (_themes.length),
              (index) => DataRow(cells: [
                    DataCell(Text(_themes[index])),
                    DataCell(Text(_scoresAnura[index].toString().toString())),
                    DataCell(Text(_scoresSajith[index].toString())),
                    DataCell(Text(_scoresRanil[index].toString())),
                    DataCell(Text(_themeTopics[index].toString())),
                    // DataCell(Text(_comparisonCategories[index])),
                    // DataCell(Text(_comparisonContent[0][index])),
                    // DataCell(Text(_comparisonContent[1][index])),
                    // DataCell(Text(_comparisonContent[2][index])),
                    // DataCell(Text(_comparisonBetter[0][index])),
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
            'Based on First and Second Votes',
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
      child: Column(children: [_buildComparisonTable()]),
    );
  }

  Widget _comparisonScoreBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(225, 245, 254, 0.75),
      ),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: _comparisonScoreChart(),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _selectThemes(),
                SizedBox(height: 16.0),
                Text(
                    'The Manifesto Comparator scores each candidate based on the volume of policies they offer within key themes, helping you see who aligns with your priorities'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final _themes = [
    'Taxation',
    'Infrastructure',
    'Social Protection',
    'Supplementary',
    'Agricultural',
    'Governance',
    'Economic Growth',
    'Law and Order',
    'Labour',
    'Education',
    'Trade and export',
    'Corruption',
    'Health',
    'IMF Programme',
    'Reconciliation',
  ];

  List<int> _selectedIndexes = [];
  var _comparisonScore = <double>[10, 10, 10];
  final _scoresAnura = <double>[
    26,
    79,
    51,
    65,
    70,
    28,
    64,
    55,
    36,
    50,
    67,
    39,
    71,
    40,
    0
  ];
  final _scoresSajith = <double>[
    74,
    16,
    33,
    19,
    20,
    52,
    14,
    35,
    50,
    27,
    25,
    57,
    21,
    40,
    17
  ];
  final _scoresRanil = <double>[
    0,
    5,
    16,
    16,
    10,
    20,
    22,
    10,
    14,
    23,
    8,
    4,
    8,
    20,
    83
  ];

  void _onThemeSelected(int index) {
    setState(() {
      // If already selected, remove from the list, otherwise add
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
      _updateComparisonScore();
    });
  }

  void _updateComparisonScore() {
    double sumAnura = 0;
    double sumSajith = 0;
    double sumRanil = 0;

    // Calculate the sum of scores for selected indexes for each candidate
    for (int index in _selectedIndexes) {
      sumAnura += _scoresAnura[index];
      sumSajith += _scoresSajith[index];
      sumRanil += _scoresRanil[index];
    }

    // get percentage values
    double totalScore = sumAnura + sumSajith + sumRanil;

    double percentageAnura =
        totalScore != 0 ? (sumAnura / totalScore) * 100 : 0;
    double percentageSajith =
        totalScore != 0 ? (sumSajith / totalScore) * 100 : 0;
    double percentageRanil =
        totalScore != 0 ? (sumRanil / totalScore) * 100 : 0;
    // Update _comparisonScore list
    _comparisonScore = [percentageAnura, percentageSajith, percentageRanil];
  }

  Widget _selectThemes() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // space between buttons
        runSpacing: 8.0, // space between rows
        children: List.generate(_themes.length, (index) {
          return ChoiceChip(
            label: Text(_themes[index]),
            selected: _selectedIndexes.contains(index),
            onSelected: (bool selected) {
              _onThemeSelected(index);
            },
          );
        }),
      ),
    );
  }

  _comparisonScoreChart() {
    Map<String, double> dataMap = {
      "Anura": _comparisonScore[0], // put the actual value here
      "Sajith": _comparisonScore[1],
      "Ranil": _comparisonScore[2],
    };

    final colorList = <Color>[
      Colors.pinkAccent,
      // Colors.yellow,
      Colors.green,
      Colors.yellow,
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
                _comparisonScoreBox(),
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
