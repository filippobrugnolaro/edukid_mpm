import 'package:edukid/core/presentation/widgets/dialog.dart';
import 'package:flutter/material.dart';

enum DialogType {
  info,
}

class DialogFactory {
  static getDialog(
      {required BuildContext context,
      required DialogType dialogType,
      String? title,
      String? description,
      VoidCallback? onButtonClicked}) {
    switch (dialogType) {
      case DialogType.info:
        return InfoDialog()
            .createDialog(context, title, description, onButtonClicked);
    }
  }

  static void showInfoDialog(
      BuildContext context, String title, String description) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DialogFactory.getDialog(
              context: context, dialogType: DialogType.info);
        });
  }
}
