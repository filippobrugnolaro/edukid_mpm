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
              return const Center(
                child: CircularProgressIndicator()
              );
            } else if (state is QuizQuestionState) {
              // Question state: Display the question and options
              return Container(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  children: [
                    Text(state.question, style: TextStyle(fontSize: 3.h),),
                    SizedBox(height: 3.h,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.options.length,
                      itemBuilder: (context, index) {
                        final option = state.options[index];
                        return Container(
                          margin: EdgeInsets.all(3.w),
                          width: 30.w,
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                    ),
                          child: ListTile(
                        
                            title: Text(option),
                            onTap: () {
                              final bloc = BlocProvider.of<QuizBloc>(context);
                              bloc.add(SubmitAnswerEvent(option));
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            else if (state is QuizResultState && state.isCorrect){
              return const Center(child: Text('risposta corretta.'));
            }
            else if (state is QuizResultState){
              return Center(child: Text(state.correctOption));
            }
            else return const Center(child: Text('wrong'));
          },
        ),
      ),
    );
  }
}

/*
return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'domanda',
                    style: TextStyle(fontSize: 3.2.h),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnswerOption(text: 'risp1', borderColor: color),
                      SizedBox(height: 2.h),
                      AnswerOption(text: 'risp2', borderColor: color),
                      SizedBox(height: 2.h),
                      AnswerOption(text: 'risp3', borderColor: color),
                      SizedBox(height: 2.h),
                      AnswerOption(text: 'risp4', borderColor: color),
                    ],
                  ),
                ],
              ),
            );

*/