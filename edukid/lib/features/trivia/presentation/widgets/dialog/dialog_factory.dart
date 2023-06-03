import 'package:edukid/features/trivia/presentation/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

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
