import 'package:edukid/core/util/Wrappers.dart';
import 'package:edukid/features/trivia/domain/usecases/GetRandomTriviaUseCase.dart';
import 'package:edukid/features/trivia/presentation/bloc/TriviaEvent.dart';
import 'package:edukid/features/trivia/presentation/bloc/TriviaState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String serverFailureMessage = 'Server Failure';

class RandomTriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final GetRandomTriviaUseCase getRandomTriviaUseCase;

  RandomTriviaBloc({required GetRandomTriviaUseCase randomTriviaUseCase}) :
        getRandomTriviaUseCase = randomTriviaUseCase,
        super(Empty()) {
    on<GetRandomTriviaEvent>(_mapEventToState);
  }

  TriviaState get initialState => Empty();

  Future<void> _mapEventToState(TriviaEvent event, Emitter<TriviaState> emit) async {
    if(event is GetRandomTriviaEvent){
      emit(Loading());
      final trivia = await getRandomTriviaUseCase.call(Params(typeQuestion: event.typeQuestion, numberQuestion: event.numberQuestion));
      trivia.fold(
              (failure) => emit(Error(message: serverFailureMessage)),
              (trivia) => emit(Loaded(trivia: trivia))
      );
    }
  }//try and catch? TO VERIFY -> warning away if code is into the on<Event> /// .call(TriviaState)
}