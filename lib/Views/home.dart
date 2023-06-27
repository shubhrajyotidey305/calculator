import 'package:calculator_redoq/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:basic_utils/basic_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String equation = "0";
  String result = "0";
  String expression = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void calculate(String buttonText) {
    setState(() {
      _scrollController
          .jumpTo(_scrollController.positions.last.maxScrollExtent);
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "DEL") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        expression = equation;
        for (int i = 0; i < expression.length; i++) {
          if (expression[i] == '%') {
            int left = i - 1;
            int right = i + 1;
            while (left >= 0 && StringUtils.isDigit(expression[left])) {
              left--;
            }
            left++;
            right++;
            expression = StringUtils.addCharAtPosition(expression, '(', left);
            expression = StringUtils.addCharAtPosition(expression, ')', right);
            i += 2;
          }
        }
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '*0.01');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          result = '${exp.evaluate(EvaluationType.REAL, ContextModel())}';
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          if (equation[equation.length - 1] == '%') {
            if (num.tryParse(buttonText) != null) {
              equation = "$equation*$buttonText";
              return;
            }
          }
          equation = equation + buttonText;
        }
      }
    });
  }

  customButton(String buttonText, Color buttonColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: buttonColor),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () => calculate(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: Config(context).height,
        width: Config(context).width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Text(
                  equation,
                  style: const TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  result,
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            Divider(thickness: 2, color: grey1),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: customButton("C", grey1)),
                        Expanded(child: customButton("7", grey2)),
                        Expanded(child: customButton("4", grey2)),
                        Expanded(child: customButton("1", grey2)),
                        Expanded(child: customButton(".", grey2)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: customButton("DEL", grey1)),
                        Expanded(child: customButton("9", grey2)),
                        Expanded(child: customButton("5", grey2)),
                        Expanded(child: customButton("2", grey2)),
                        Expanded(child: customButton("0", grey2)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: customButton("%", grey1)),
                        Expanded(child: customButton("8", grey2)),
                        Expanded(child: customButton("6", grey2)),
                        Expanded(child: customButton("3", grey2)),
                        Expanded(child: customButton("00", grey2)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: customButton("×", purple1)),
                        Expanded(child: customButton("÷", purple1)),
                        Expanded(child: customButton("-", purple1)),
                        Expanded(child: customButton("+", purple1)),
                        Expanded(child: customButton("=", purple2)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
