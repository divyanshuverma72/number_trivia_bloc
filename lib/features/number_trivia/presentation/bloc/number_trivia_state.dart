part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]) : super();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  Loaded({required this.numberTrivia}) : super([numberTrivia]);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Error extends NumberTriviaState {
  final String message;
  Error({required this.message}) : super([message]);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
