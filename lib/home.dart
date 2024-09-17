import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'compare.dart';

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
      final response = await http.get(Uri.parse(apiUrl + '/win-prediction'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Win Pediction'),
        centerTitle: true,
      ),
      // body: buildPieChart(
      //   candidate1WinPercentage: candidate1WinPercentage,
      //   candidate2WinPercentage: candidate2WinPercentage,
      // ), ///////////////////////////////////////////////////////////
      // body: Stack(children: [_buildPieChart(), CompareScreen()]),
      // body: Center(
      //   child: isLoading ? CircularProgressIndicator() : _buildPieChart(),
      // ),
    );
  }
}

// class buildPieChart extends StatelessWidget {
//   final double candidate1WinPercentage;
//   final double candidate2WinPercentage;

//   buildPieChart({
//     required this.candidate1WinPercentage,
//     required this.candidate2WinPercentage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PieChart(
//       PieChartData(
//         startDegreeOffset: 90,
//         sections: [
//           PieChartSectionData(
//             value: candidate1WinPercentage,
//             color: Colors.blue,
//             title:
//                 'Candidate 1\n${candidate1WinPercentage.toStringAsFixed(1)}%',
//             radius: 100,
//             titleStyle: TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           PieChartSectionData(
//             value: candidate2WinPercentage,
//             color: Colors.red,
//             title:
//                 'Candidate 2\n${candidate2WinPercentage.toStringAsFixed(1)}%',
//             radius: 100,
//             titleStyle: TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//         borderData: FlBorderData(show: false),
//         sectionsSpace: 2,
//         centerSpaceRadius: 0,
//       ),
//     );
//   }
// }
