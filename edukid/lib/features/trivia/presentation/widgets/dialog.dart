import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../config/colors.dart' as app_colors;

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
        'Ciao io sono Monky! Divertiti e sfida i tuoi amici imparando.Per ogni risposta giusta otterrai 10 gettoni, ma attenzione! Se darai la risposta sbagliata ne perderai 5!'
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
            child: const Text('chiudi'))
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
