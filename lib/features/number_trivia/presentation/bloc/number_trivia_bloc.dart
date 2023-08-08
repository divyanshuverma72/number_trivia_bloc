import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({required this.getConcreteNumberTrivia, required this.getRandomNumberTrivia, required this.inputConverter}) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
      inputConverter.stringToUnsignedInteger(event.numberString);

       await inputEither.fold(
            (failure) {
          emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
            (integer) async {
              emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
              emit(failureOrTrivia.fold((failure) => Error(message: _mapFailureToMessage(failure)),
                      (trivia) => Loaded(numberTrivia: trivia)));
        },
      );
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      emit(failureOrTrivia.fold((failure) => Error(message: _mapFailureToMessage(failure)),
              (trivia) => Loaded(numberTrivia: trivia)));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else {
      return CACHE_FAILURE_MESSAGE;
    }
  }

  NumberTriviaState get initialState => Empty();
}
