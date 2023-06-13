
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialog_factory.dart';
import 'package:flutter/material.dart';
import '../config/colors.dart' as app_colors;

class ClickableImage extends StatelessWidget {

  const ClickableImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
        DialogFactory.showInfoDialog(context, '', '');
      },
          child: const Icon(
            Icons.info_outline,
            size: 48,
            color: app_colors.orange,
          ),
      //child: Image.asset('images/info.png', height: 16.h,),
    );
  }
}
