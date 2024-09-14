import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui';

class HomeScreenGenerator extends StatefulWidget {
  const HomeScreenGenerator({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Text('Home Screen'),
    );
  }
}
