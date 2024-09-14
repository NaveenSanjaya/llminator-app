import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui';

class CompareScreenGenerator extends StatefulWidget {
  const CompareScreenGenerator({super.key});

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreenGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manifesto Comparator'),
      ),
      body: Text('Compare Screen'),
    );
  }
}
