import 'package:edukid/features/trivia/data/repositories/RandomTriviaRepositoryImpl.dart';
import 'package:edukid/features/trivia/domain/entities/RandomTrivia.dart';
import 'package:edukid/features/trivia/domain/repositories/RandomTriviaRepository.dart';
import 'package:edukid/features/trivia/domain/usecases/GetRandomTriviaUseCase.dart';
import 'package:edukid/features/trivia/presentation/screens/question/bloc/question_bloc.dart';
import 'package:edukid/features/trivia/presentation/widgets/answer.dart';
import 'package:edukid/features/trivia/presentation/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import '../../config/colors.dart' as app_colors;

class QuestionPage extends StatelessWidget {
  final Color color;
  final String title;

  //dependency injection
  late QuizRepo quizRepo;

  QuestionPage({
    Key? key,
    required this.color,
    required this.title,
    required this.quizRepo,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(quizRepo),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 2.5.h),
          ),
          centerTitle: true,
          backgroundColor: color,
        ),
        body: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInitialState) {
              final bloc = BlocProvider.of<QuizBloc>(context);
              bloc.add(LoadQuizEvent());
              // Initial state: Display loading indicator or fetch quiz data
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuizQuestionState) {
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
                                  BlocProvider.of<QuizBloc>(context).add(
                                    SelectOptionEvent(option),
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
                              BlocProvider.of<QuizBloc>(context).add(
                                  SubmitAnswerEvent(state.question
                                      .options[state.selectedOptionIndex]));
                            }
                          },
                          child: Text('Consegna'),
                        ),
                      ],
                    ))
              ]);
            }
            if (state is QuizResultState) {
              return Center(
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
                              BlocProvider.of<QuizBloc>(context)
                                  .add(LoadQuizEvent());
                            },
                            child: const Text('Vai alla prossima domanda')),
                        const Text('oppure'),
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
                            child: const Text('Cambia categoria',
                                style: TextStyle(color: app_colors.black))),
                        SizedBox(
                          height: 8.h,
                        )
                      ]),
                ),
              );
            } else if (state is QuizErrorState) {
              return Text(state.errorMessage);
            } else
              return Text('Si è verificato un errore');
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
      Text('Complimenti! Hai dato la risposta corretta. Ecco a te 10 gettoni.'),
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
      Text('La risposta corretta era $correctAnswer.',
          style: TextStyle(fontSize: 10.sp)),
      SizedBox(height: 4.h),
      Text('Purtroppo hai perso 5 gettoni!'),
      SizedBox(height: 2.h),
      Text('Rispondi correttamente alla prossima domanda per rimediare!'),
    ]);
  }

  Widget getDialog(dynamic context) {
    return AlertDialog(
      title: const Text('Attenzione!'),
      content: const Text('Devi selezionare almeno un opzione!'),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ho capito.'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
