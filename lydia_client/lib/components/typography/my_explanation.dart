import 'package:flutter/material.dart';

class MyExplanation extends StatelessWidget {
  final String text;

  const MyExplanation(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
