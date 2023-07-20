import 'package:edukid/core/config/colors.dart' as app_colors;
import 'package:edukid/di_container.dart';
import 'package:edukid/features/trivia_question/presentation/bloc/question_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class QuestionPage extends StatelessWidget {
  final Color color;
  final String title;

  QuestionPage({
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
            style: TextStyle(fontSize: 2.5.h),
          ),
          centerTitle: true,
          backgroundColor: color,
        ),
        body: BlocBuilder<TriviaBloc, TriviaState>(
          builder: (context, state) {
            if (state is TriviaInitialState) {
              final bloc = BlocProvider.of<TriviaBloc>(context);
              bloc.add(LoadTriviaEvent(title));
              // Initial state: Display loading indicator or fetch quiz data
              return const Center(child: CircularProgressIndicator());
            } else if (state is TriviaQuestionState) {
              // Question state: Display the question and options
              return Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/doodle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        Text(
                          state.question.question,
                          style: TextStyle(fontSize: 3.h),
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                color), // Set the background color
                          ),
                          onPressed: () {
                            // Aggiungi l'evento per consegnare la domanda
                            if (state.selectedOptionIndex == -1) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return getDialog(context);
                                  });
                            } else {
                              BlocProvider.of<TriviaBloc>(context).add(
                                  SubmitTriviaAnswerEvent(state.question
                                      .options[state.selectedOptionIndex]));
                            }
                          },
                          child: Text('Submit'),
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
                      image: AssetImage('images/doodle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        state.isCorrect
                            ? getCorrect()
                            : getWrong(state.correctOption),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  color), // Set the background color
                            ),
                            onPressed: () {
                              BlocProvider.of<TriviaBloc>(context)
                                  .add(LoadTriviaEvent(title));
                            },
                            child: const Text('Next question')),
                        const Text('or'),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  app_colors.white), //
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: color, width: 2.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('getStarted');
                            },
                            child: const Text('Change category',
                                style: TextStyle(color: app_colors.black))),
                        SizedBox(
                          height: 8.h,
                        )
                      ]),
                ),
              )]);
            } else if (state is TriviaErrorState) {
              return Text(state.errorMessage);
            } else
              return Text('Sorry an error occured!');
          },
        ),
      ),
    );
  }

  Widget getCorrect() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Column(
        children: [
          Image.asset(
            'images/coin.png',
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
      Text('You earned 10 coins!'),
    ]);
  }

  Widget getWrong(String correctAnswer) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Column(
        children: [
          Image.asset(
            'images/coin.png',
            width: 20.w,
          ),
          Text(
            'Oh no!',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: app_colors.red),
          ),
          Text(
            '-5',
            softWrap: true,
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: app_colors.red),
          )
        ],
      ),
      Text('Correct answer was: $correctAnswer.',
          style: TextStyle(fontSize: 10.sp)),
      SizedBox(height: 4.h),
      Text('Unluckily you lost 5 coins!'),
      SizedBox(height: 2.h),
      Text('Try to answer the next question correctly to earn them back!'),
    ]);
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
          child: Text('Understood.'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
