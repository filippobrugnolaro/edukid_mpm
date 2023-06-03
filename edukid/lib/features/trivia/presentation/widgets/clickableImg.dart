import 'package:edukid/features/trivia/presentation/widgets/dialog.dart';
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialogBloc.dart';
import 'package:edukid/features/trivia/presentation/widgets/dialog/dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ClickableImage extends StatelessWidget {

  const ClickableImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DialogFactory.showInfoDialog(context, 'Tutorial', 'Ciao io sono Monky!');
      },
      child: Image.asset('images/monkey.png', width: 15.w,),
    );
  }
}
