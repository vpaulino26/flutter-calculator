import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluationer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Victor\'s Calculator App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My Calculator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = '';
  String _result = '';
  final _buttonLabels = [
    ['7', '8', '9', '/'],
    ['4', '5', '6', '*'],
    ['1', '2', '3', '-'],
    ['C', '0', '=', '+'],
  ];

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _expression = '';
        _result = '';
      } else if (label == '=') {
        if (_expression.isEmpty) return;
        try {
          final exp = Expression.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          String resultStr = evalResult.toString();
          if (resultStr == 'Infinity' || resultStr == '-Infinity' || resultStr == 'NaN') {
            _result = 'Undefined';
          } else {
            _result = resultStr;
          }
          _expression += ' = $_result';
        } catch (e) {
          _result = 'Error';
          _expression += ' = Error';
        }
      } else {
        if (_expression.contains('='))
          _expression = '';
        _expression += label;
      }
    });
  }

  Widget _buildButton(String label) {
    Color color;
    if (label == 'C') {
      color = Colors.redAccent;
    } else if ('/*-+='.contains(label)) {
      color = Colors.deepPurple;
    } else {
      color = Colors.grey[800]!;
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 24),
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _onButtonPressed(label),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Row(
      children: labels.map(_buildButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Victor\'s Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(fontSize: 28, color: Colors.black87),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_result.isNotEmpty && !_expression.endsWith(_result))
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 36, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buttonLabels.map(_buildButtonRow).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
