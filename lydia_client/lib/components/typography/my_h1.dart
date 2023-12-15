import 'package:flutter/material.dart';

class MyH1 extends StatelessWidget {
  final String text;

  const MyH1(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.displayMedium);
  }
}
