/*
Right Vote - A web app for election prediction and manifesto comparison with machine learning and NLP.
Nilakna Warushavithana, September 2024
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:llminator/chatbot.dart';
import 'package:llminator/compare.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // root widget
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'llminators',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade400,
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // state and logic
  // notifyListeners();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Image bgimage = Image.asset('assets/bg.jpg');
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const CompareScreen(),
    // const HomeScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showChatBotPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.4,
                heightFactor: 0.9,
                child: Material(
                  elevation: 16,
                  child: ChatBotPanel(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Right Vote'),
          leading: Icon(Icons.how_to_vote),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showChatBotPanel(context),
          tooltip: 'Ask Bot', // put our bot a name
          child: const Icon(Icons.chat_rounded),
        ),
        body: _tabs[_currentIndex],
      ),
    );
  }
}

// class HomeScreen extends HomeScreenGenerator {
//   const HomeScreen({super.key});
// }

class CompareScreen extends CompareScreenGenerator {
  const CompareScreen({super.key});
}

class ChatBotPanel extends ChatBotPanelGenerator {
  const ChatBotPanel({super.key});
}
