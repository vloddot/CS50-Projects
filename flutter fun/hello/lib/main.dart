import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String title = 'Hello world!';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello world!',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _number1 = 0;
  int _number2 = 0;

  void updateNumber1(String number) {
    int? intNumber = int.tryParse(number);

    if (intNumber != null) {
      setState(() {
        _number1 = intNumber;
      });
    }
  }

  void updateNumber2(String number) {
    int? intNumber = int.tryParse(number);

    if (intNumber != null) {
      setState(() {
        _number2 = intNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose number'),
              TextField(
                onChanged: updateNumber1,
              ),
              const Text('Choose another number'),
              TextField(onChanged: updateNumber2),
              Text('${_number1 + _number2}'),
            ],
          ),
        ),
      ),
    );
  }
}
