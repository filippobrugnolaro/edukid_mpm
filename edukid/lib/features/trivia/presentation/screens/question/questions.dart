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
              // Initial state: Display loading indicator or fetch quiz data
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is QuizQuestionState) {
              // Question state: Display the question and options
              return Column(
                children: [
                  Text(state.question),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.options.length,
                    itemBuilder: (context, index) {
                      final option = state.options[index];
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          final bloc = BlocProvider.of<QuizBloc>(context);
                          bloc.add(SubmitAnswerEvent(option));
                        },
                      );
                    },
                  ),
                ],
              );
            }
            else if (state is QuizResultState){
              return const Center(child: Text('results'));
            }
            else return const Center(child: Text('qualcosa is wrong'));
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