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
           automaticallyImplyLeading: false
        ),
        body: BlocBuilder<TriviaBloc, TriviaState>(
          builder: (context, state) {
            if (state is TriviaInitialState) {
              final bloc = BlocProvider.of<TriviaBloc>(context);
              bloc.add(LoadTriviaEvent(title));
              // Initial state: Display loading indicator or fetch quiz data
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color),));
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
                Container(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        SizedBox(height:2.h),
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
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(2.h)),
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
                                  SubmitTriviaAnswerEvent(state.question
                                      .options[state.selectedOptionIndex], title));
                            }
                          },
                          child: Text("Submit",
                            style: TextStyle(fontSize: 13.0.sp)),
                        ),
                      ],
                    ))
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
                Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      state.isCorrect
                          ? getCorrect()
                          : getWrong(state.correctOption),
                      ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(2.h)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                color), // Set the background color
                          ),
                          onPressed: () {
                            BlocProvider.of<TriviaBloc>(context)
                                .add(LoadTriviaEvent(title));
                          },
                          child: Text('Next question', style: TextStyle(fontSize: 13.sp))),
                      Text('or',style: TextStyle(fontSize: 13.sp),),
                      ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.all(2.h)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                app_colors.white), //
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: color, width: 2.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('getStarted');
                          },
                          child:  Text('Back to the home page',
                              style: TextStyle(color: app_colors.black, fontSize: 13.sp))),
                      SizedBox(
                        height: 8.h,
                      )
                    ]),
              )]);
            } else if (state is TriviaErrorState) {
              return Stack(fit: StackFit.expand,
                  children: [
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color),)),
                    AlertDialog(
                      actionsPadding: const EdgeInsets.all(20),
                      title: const Text('Error'),
                      content: Text(state.errorMessage),
                      actions: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: app_colors.orange),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok')),
                      ],
                    ),
                  ],
              );
            } else {
              return const Text('Unknown error');
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
          Image.asset(
            'assets/images/coin.png',
            width: 20.w,
          ),
          Text(
            '+10',
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: app_colors.green),
          )
        ],
      ),
      Text('Correct!', style: TextStyle(fontSize: 25.sp)),
      Text('You earned 10 coins!', style: TextStyle(fontSize: 13.sp)),
    ]));
  }

  Widget getWrong(String correctAnswer) {
    return SizedBox(
      width: 85.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  '-5',
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
              'Correct answer was: $correctAnswer.',
              style: TextStyle(fontSize: 15.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              'Unluckily you lost 5 coins!',
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Try to answer the next question correctly to earn them back! ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDialog(dynamic context) {
    return AlertDialog(
      title: const Text('Careful!'),
      content: const Text('You need to select at least one option!'),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Understood.'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
