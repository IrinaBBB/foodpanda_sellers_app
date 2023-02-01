import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;

  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Center(
            child: Text("Ok"),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
