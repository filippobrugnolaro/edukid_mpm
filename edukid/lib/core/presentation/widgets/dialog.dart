import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

abstract class Dialog {
  AlertDialog createDialog(BuildContext context, String title,
      String description, VoidCallback? onButtonClicked);
}

class InfoDialog extends Dialog {
  @override
  AlertDialog createDialog(BuildContext context, String? title,
      String? description, VoidCallback? onButtonClicked) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.info,
              color: app_colors.orange,
              size: (SizerUtil.deviceType == DeviceType.mobile ? null : 4.0.w)),
          const SizedBox(
            width: 10,
          ),
          Text(description ?? 'Tutorial')
        ],
      ),
      content: Text(description ?? 
        'Have fun and challenge your friends while learning!\nFor each correct answer you will earn 10 coins but be careful! If your answer is wrong you will lose 5.'
      ),
      actionsPadding: const EdgeInsets.all(20),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
            onPressed: () {
              if (onButtonClicked != null) {
                onButtonClicked();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Close'))
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
