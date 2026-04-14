import 'package:flexible_image/flexible_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlexibleImage(
          fit: BoxFit.cover,
          source: FlexibleImageSource.fromNullableSource(
            'https://images.pexels.com/photos/36532461/pexels-photo-36532461.jpeg',
          ),
        ),
      ),
    );
  }
}
