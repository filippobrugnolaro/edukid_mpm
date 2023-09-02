import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/core/presentation/widgets/menu_drawer.dart';
import 'package:edukid/features/get_started/presentation/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Istruzioni'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Now Scaffold.of(context) will work correctly
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          backgroundColor: app_colors.orange,
        ),
        drawer: const MenuDrawer(
          pageNumber: 3,
        ),
        body: Stack(fit: StackFit.expand, children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/doodle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aiuta Jack a ri-ottenere le sue monete!',
                    style: TextStyle(fontSize: 13.sp),
                    softWrap: true,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '1. Questo gioco consiste in domande a risposta multipla, divise per materie.\nSolo una risposta è corretta.',
                    style: TextStyle(fontSize: 12.5.sp),
                    softWrap: true,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '2. Rispondi correttamente alla domanda per ottenere 5 monete.',
                    style: TextStyle(fontSize: 12.5.sp),
                    softWrap: true,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '3. Se la tua risposta è errata, ne perderai 3!',
                    style: TextStyle(fontSize: 12.5.sp),
                    softWrap: true,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "4. Puoi monitorare il tuo progresso nella sezione 'Statistiche'.\nProva a battere il tuo punteggio!",
                    style: TextStyle(fontSize: 12.5.sp),
                    softWrap: true,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/correct.png',
                          width: 40.w,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: app_colors.orange,
                              padding:
                                  EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h)),
                          onPressed: () {
                            // Navigate to the quiz page when the user taps the "Start Quiz" button
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GetStartedPage(),
                              ),
                            );
                          },
                          child:
                              Text('Gioca!', style: TextStyle(fontSize: 13.sp)),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ]));
  }
}
