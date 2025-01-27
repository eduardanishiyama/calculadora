import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String entrada = '';
  String resultado = '';

  void addInput(String text) {
    setState(() {
      entrada += text;
    });
  }

  void calcularResultado() {
    try {
      // Aqui você pode usar o método evaluate da classe Expression
      final double eval = _evaluateExpression(entrada);
      setState(() {
        resultado = eval.toString();
      });
    } catch (e) {
      setState(() {
        resultado = 'Erro';
      });
    }
  }

  double _evaluateExpression(String expression) {
    final List<String> tokens = _tokenize(expression);
    final List<double> values = [];
    final List<String> operators = [];

    for (final token in tokens) {
      if (_isOperator(token)) {
        while (operators.isNotEmpty && _hasPrecedence(token, operators.last)) {
          final double b = values.removeLast();
          final double a = values.removeLast();
          final String op = operators.removeLast();
          values.add(_applyOperator(a, b, op));
        }
        operators.add(token);
      } else {
        values.add(double.parse(token));
      }
    }

    while (operators.isNotEmpty) {
      final double b = values.removeLast();
      final double a = values.removeLast();
      final String op = operators.removeLast();
      values.add(_applyOperator(a, b, op));
    }

    return values.single;
  }

  List<String> _tokenize(String expression) {
    final RegExp regex = RegExp(r'([+\-*/])');
    return expression.split(regex).where((token) => token.isNotEmpty).toList();
  }

  bool _isOperator(String token) {
    return token == '+' || token == '-' || token == '*' || token == '/';
  }

  bool _hasPrecedence(String op1, String op2) {
    if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-')) {
      return false;
    }
    return true;
  }

  double _applyOperator(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a / b;
      default:
        throw ArgumentError('Operador desconhecido: $op');
    }
  }

  void limpar() {
    setState(() {
      entrada = '';
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: Text(
                entrada,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomRight,
              child: Text(
                resultado,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => addInput('1'),
                child: Text('1'),
              ),
              ElevatedButton(
                onPressed: () => addInput('2'),
                child: Text('2'),
              ),
              ElevatedButton(
                onPressed: () => addInput('3'),
                child: Text('3'),
              ),
              ElevatedButton(
                onPressed: () => addInput('+'),
                child: Text('+'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => addInput('4'),
                child: Text('4'),
              ),
              ElevatedButton(
                onPressed: () => addInput('5'),
                child: Text('5'),
              ),
              ElevatedButton(
                onPressed: () => addInput('6'),
                child: Text('6'),
              ),
              ElevatedButton(
                onPressed: () => addInput('-'),
                child: Text('-'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => addInput('7'),
                child: Text('7'),
              ),
              ElevatedButton(
                onPressed: () => addInput('8'),
                child: Text('8'),
              ),
              ElevatedButton(
                onPressed: () => addInput('9'),
                child: Text('9'),
              ),
              ElevatedButton(
                onPressed: () => addInput('*'),
                child: Text('*'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => addInput('0'),
                child: Text('0'),
              ),
              ElevatedButton(
                onPressed: () => addInput('.'),
                child: Text('.'),
              ),
              ElevatedButton(
                onPressed: () => addInput('/'),
                child: Text('/'),
              ),
              ElevatedButton(
                onPressed: calcularResultado,
                child: Text('='),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: limpar,
                child: Text('C'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
