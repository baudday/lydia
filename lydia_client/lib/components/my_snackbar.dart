import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  final String message;

  const MySnackBar(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 20),
              Text(message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        )
      ],
    );
  }
}
