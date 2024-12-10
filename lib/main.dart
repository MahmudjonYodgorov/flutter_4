import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = "0"; // Ekranda ko'rsatiladigan matn
  double? firstOperand; // Birinchi operand
  String? operator; // Operator (+, -, *, /)
  bool isTypingSecondOperand = false; // Ikkinchi operandni kiritish belgisi

  // Natijani formatlash
  String formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString(); // Butun son uchun
    } else {
      return value.toString(); // Kasr son uchun
    }
  }

  // Hisoblash
  double calculate(double first, double second, String operator) {
    switch (operator) {
      case "+":
        return first + second;
      case "-":
        return first - second;
      case "*":
        return first * second;
      case "/":
        return second != 0 ? first / second : double.nan;
      case "x^x":
        return pow(first, second).toDouble();
      default:
        return first;
    }
  }


  void onButtonPressed(String value) {
    setState(() {
      // Agar son yoki nuqta bo'lsa
      if (double.tryParse(value) != null || value == ".") {
        if (value == "." && displayText.contains("."))
          return; // Ko'p nuqtalarni oldini olish
        displayText = (displayText == "0" ? value : displayText + value);
      }
      // Operator bosilganda
      else if (value == "+" ||
          value == "-" ||
          value == "*" ||
          value == "/" ||
          value == "x^x") {
        if (!isTypingSecondOperand) {
          firstOperand = double.tryParse(displayText);
          operator = value;
          isTypingSecondOperand = true;
          displayText = "0"; // Ikkinchi operandni boshlash
        } else {
          double secondOperand = double.tryParse(displayText) ?? 0;
          firstOperand = calculate(firstOperand!, secondOperand, operator!);
          operator = value;
          displayText = "0";
        }
      }
      // Maxsus operatorlar
      else if (value == "sin" ||
          value == "cos" ||
          value == "tan" ||
          value == "√" ||
          value == "1/x") {
        double operand = double.tryParse(displayText) ?? 0;
        switch (value) {
          case "sin":
            displayText = formatResult(sin(operand * pi / 180));
            break;
          case "cos":
            displayText = formatResult(cos(operand * pi / 180));
            break;
          case "tan":
            displayText = (operand % 180 == 90)
                ? "Error"
                : formatResult(tan(operand * pi / 180));
            break;
          case "√":
            displayText = operand >= 0 ? formatResult(sqrt(operand)) : "Error";
            break;
          case "1/x":
            displayText = operand != 0 ? formatResult(1 / operand) : "Error";
            break;
        }
        isTypingSecondOperand = false;
        firstOperand = null;
        operator = null;
      }
      // Hisoblashni bajarish
      else if (value == "=") {
        if (firstOperand != null && operator != null) {
          double secondOperand = double.tryParse(displayText) ?? 0;
          displayText =
              formatResult(calculate(firstOperand!, secondOperand, operator!));
          firstOperand = null;
          operator = null;
          isTypingSecondOperand = false;
        }
      }
      // Tozalash tugmasi
      else if (value == "C") {
        displayText = "0";
        firstOperand = null;
        operator = null;
        isTypingSecondOperand = false;
      }
    });
  }


  Widget buildButton(String label, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: color,
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                displayText,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("1", Colors.grey),
                  buildButton("2", Colors.grey),
                  buildButton("3", Colors.grey),
                  buildButton("4", Colors.grey),
                ],
              ),
              Row(
                children: [
                  buildButton("5", Colors.grey),
                  buildButton("6", Colors.grey),
                  buildButton("7", Colors.grey),
                  buildButton("8", Colors.grey),
                ],
              ),
              Row(
                children: [
                  buildButton("9", Colors.grey),
                  buildButton("0", Colors.grey),
                  buildButton("+", Colors.grey),
                  buildButton("-", Colors.grey),
                ],
              ),
              Row(
                children: [
                  buildButton("*", Colors.grey),
                  buildButton("/", Colors.grey),
                  buildButton("x*x", Colors.grey),
                  buildButton("√", Colors.grey),
                ],
              ),
              Row(
                children: [
                  buildButton("1/x", Colors.grey),
                  buildButton("cos", Colors.grey),
                  buildButton("sin", Colors.grey),
                  buildButton("tan", Colors.grey),
                ],
              ),
                Row(
                  children: [
                    buildButton("=", Colors.grey),
                    buildButton("C", Colors.grey),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

