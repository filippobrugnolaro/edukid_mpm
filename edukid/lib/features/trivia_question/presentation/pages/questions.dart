import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/di_container.dart';
import 'package:edukid/features/trivia_question/presentation/bloc/question_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class QuestionPage extends StatelessWidget {
  final Color color;
  final String title;

  const QuestionPage({
    Key? key,
    required this.color,
    required this.title,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TriviaBloc>(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              title,
            ),
            centerTitle: true,
            backgroundColor: color,
            automaticallyImplyLeading: false,
            leading: BlocBuilder<TriviaBloc, TriviaState>(
              builder: (context, state) {
              if (state is TriviaQuestionState) {
                return BackButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('getStarted'),
                );
              }
              return const SizedBox();
              },
            ),
        ),
        body: BlocBuilder<TriviaBloc, TriviaState>(
          builder: (context, state) {
            if (state is TriviaInitialState) {
              final bloc = BlocProvider.of<TriviaBloc>(context);
              bloc.add(LoadTriviaEvent(title));
            } else if (state is TriviaLoadingState) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ));
            } else if (state is TriviaQuestionState) {
              // Question state: Display the question and options
              return Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/doodle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                child: Center(
                child: Container(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          state.question.question,
                          style: TextStyle(fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.question.options.length,
                          itemBuilder: (context, index) {
                            final option = state.question.options[index];
                            final isSelected =
                                index == state.selectedOptionIndex;
                            final backColor =
                                isSelected ? color : app_colors.white;

                            return Container(
                              margin: EdgeInsets.all(3.w),
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: backColor,
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(
                                      color: isSelected
                                          ? app_colors.white
                                          : Colors.black),
                                ),
                                onTap: () {
                                  BlocProvider.of<TriviaBloc>(context).add(
                                    SelectTriviaOptionEvent(option),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 5.h),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                color), // Set the background color
                          ),
                          onPressed: () {
                            if (state.selectedOptionIndex == -1) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return getDialog(context);
                                  });
                            } else {
                              BlocProvider.of<TriviaBloc>(context).add(
                                  SubmitTriviaAnswerEvent(
                                      state.question
                                          .options[state.selectedOptionIndex],
                                      title));
                            }
                          },
                          child: Text("Submit",
                              style: TextStyle(fontSize: 13.0.sp)),
                        ),
                      ],
                    ))
                  )
                )
              ]);
            }
            if (state is TriviaResultState) {
              return Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/doodle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Column(children: [
                      state.isCorrect
                          ? getCorrect()
                          : getWrong(state.correctOption),
                      SizedBox(
                        height: 4.h,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                color), // Set the background color
                          ),
                          onPressed: () {
                            BlocProvider.of<TriviaBloc>(context)
                                .add(LoadTriviaEvent(title));
                          },
                          child: Text('Next question',
                              style: TextStyle(fontSize: 13.sp))),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'or',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                app_colors.white), //
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: color, width: 2.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('getStarted');
                          },
                          child: Text('Back to the home page',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: app_colors.black, fontSize: 13.sp))),
                      SizedBox(
                        height: 8.h,
                      )
                    ]),
                  ),
                )
              ]);
            } else if (state is TriviaErrorState) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  )),
                  AlertDialog(
                    actionsPadding: const EdgeInsets.all(20),
                    title: Text('Error', style: TextStyle(fontSize: 14.sp)),
                    content: Text(
                        state.errorMessage.replaceFirst('Exception: ', ''),
                        style: TextStyle(fontSize: 13.sp)),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h),
                              backgroundColor: app_colors.orange),
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "getStarted");
                          },
                          child: Text('Ok', style: TextStyle(fontSize: 13.sp))),
                    ],
                  ),
                ],
              );
            } else {
              return Text('Unknown error', style: TextStyle(fontSize: 13.sp));
            }
          },
        ),
      ),
    );
  }

  Widget getCorrect() {
    return SizedBox(
        width: 85.w,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Image.asset(
                'assets/images/coin.png',
                width: 20.w,
              ),
              Text(
                '+5',
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    color: app_colors.green),
              )
            ],
          ),
          Text('Correct!', style: TextStyle(fontSize: 25.sp)),
          Text('You earned 5 coins!', style: TextStyle(fontSize: 13.sp)),
          SizedBox(
            height: 2.h,
          ),
          Image.asset(
            'assets/images/correct.png',
            width: 40.w,
          ),
        ]));
  }

  Widget getWrong(String correctAnswer) {
    return SizedBox(
      width: 85.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 2.h),
            Column(
              children: [
                Image.asset(
                  'assets/images/coin.png',
                  width: 20.w,
                ),
                Text(
                  'Oh no!',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: app_colors.red,
                  ),
                ),
                Text(
                  '-3',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    color: app_colors.red,
                  ),
                ),
              ],
            ),
            Text(
              'Correct answer was: \n$correctAnswer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
              ),
            ),
            Text(
              'You lost 3 coins!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 2.h),
            Image.asset(
              'assets/images/wrong.png',
              width: 40.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget getDialog(dynamic context) {
    return AlertDialog(
      title: Text('Careful!', style: TextStyle(fontSize: 14.sp)),
      content: Text('You need to select at least one option!',
          style: TextStyle(fontSize: 13.sp)),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.fromLTRB(4.w, 1.3.h, 4.w, 1.3.h),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Understood.', style: TextStyle(fontSize: 13.sp)),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
