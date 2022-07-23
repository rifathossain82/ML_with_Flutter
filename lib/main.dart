import 'package:flutter/material.dart';
import 'package:ml_flutter/src/view/screen/homepage.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML with Flutter',
      home: Homepage(),
    );
  }
}
