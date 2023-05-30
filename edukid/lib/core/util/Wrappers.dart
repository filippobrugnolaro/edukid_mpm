import 'package:equatable/equatable.dart';

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final String typeQuestion;
  final String numberQuestion;

  const Params({required this.typeQuestion, required this.numberQuestion});

  @override
  List<Object> get props => [typeQuestion, numberQuestion];
}