import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomeScreenGenerator extends StatefulWidget {
  const HomeScreenGenerator({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenGenerator> {
  final String apiUrl =
      'YOUR_FIREBASE_FUNCTION_URL_HERE'; // Replace with your Firebase function URL
  double candidate1WinPercentage = 0.5;
  double candidate2WinPercentage = 0.5;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWinPrediction();
  }

  Future<void> _fetchWinPrediction() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/win-prediction'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          candidate1WinPercentage = responseData['candidate1'] ?? 0.0;
          candidate2WinPercentage = responseData['candidate2'] ?? 0.0;
          isLoading = false;
        });
      } else {
        print('Error fetching prediction: ${response.statusCode}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        startDegreeOffset: 90,
        sections: [
          PieChartSectionData(
            value: candidate1WinPercentage,
            color: Colors.blue,
            title:
                'Candidate 1\n${candidate1WinPercentage.toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: candidate2WinPercentage,
            color: Colors.red,
            title:
                'Candidate 2\n${candidate2WinPercentage.toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Win Pediction'),
  //       centerTitle: true,
  //     ),
  //     body: _buildPieChart(),
  //     // body: Center(
  //     //   child: isLoading ? CircularProgressIndicator() : _buildPieChart(),
  //     // ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Win Prediction'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Use Expanded to take up available space
          Expanded(
            child: _buildPieChart(),
          ),

          // Add some spacing between the pie chart and the button
          const SizedBox(height: 20),

          // Button to upload JSON data
          // ElevatedButton(
          //   onPressed: () {
          //     uploadJsonData();
          //   },
          //   child: const Text('Upload JSON Data'),
          // ),

          const SizedBox(height: 20), // Additional spacing if needed
        ],
      ),
    );
  }
}
