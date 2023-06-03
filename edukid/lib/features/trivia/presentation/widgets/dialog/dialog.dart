import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tutorial'),
      content: Text('Ciao! Io sono Monky!'),
      actions: [
        ElevatedButton(
          child: Text('Chiudi'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
