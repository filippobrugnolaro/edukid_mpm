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
              return Container(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    children: [
                      Text(
                        state.question,
                        style: TextStyle(fontSize: 3.h),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.options.length,
                        itemBuilder: (context, index) {
                          final option = state.options[index];
                          final isSelected = index == state.selectedOptionIndex;

                          return Container(
                            margin: EdgeInsets.all(3.w),
                            width: 30.w,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              title: Text(
                                option,
                                style: TextStyle(
                                    color: isSelected ? color : Colors.black),
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
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              color), // Set the background color
                        ),
                        onPressed: () {
                          // Aggiungi l'evento per consegnare la domanda
                          BlocProvider.of<QuizBloc>(context).add(
                              SubmitAnswerEvent(
                                  state.options[state.selectedOptionIndex]));
                        },
                        child: Text('Consegna'),
                      ),
                    ],
                  ));
            }
            if (state is QuizResultState) {
              return Center(
                child: Container(
                  child: Column(children: [
                    state.isCorrect
                        ? getCorrect()
                        : getWrong(state.correctOption),
                    SizedBox(
                      height: 4.h,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              color), // Set the background color
                        ),
                        onPressed: () {
                          BlocProvider.of<QuizBloc>(context)
                              .add(LoadQuizEvent());
                        },
                        child: Text('Vai alla prossima domanda')),
                    SizedBox(
                      height: 10.h,
                    ),
                  ]),
                ),
              );
            } else {
              return Text('Si è verificato un errore.');
            }
          },
        ),
      ),
    );
  }

  Widget getCorrect() {
    return Column(children: [
      Image.asset(
        'images/10pts.png',
        width: 40.w,
      ),
      Text('Complimenti! Hai dato la risposta corretta. Ecco a te 10 gettoni.'),
    ]);
  }

  Widget getWrong(String correctAnswer) {
    return Column(children: [
      Image.asset(
        'images/min5pts.png',
        width: 40.w,
      ),
      Text('Oh no! La risposta corretta era ${correctAnswer}.'),
      Text('Purtroppo hai perso 5 gettoni!')
    ]);
  }
}
