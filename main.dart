import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme.dart';

void main() {
  runApp(const FurniApp());
}

class FurniApp extends StatelessWidget {
  const FurniApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furni Store',
      theme: furniTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
