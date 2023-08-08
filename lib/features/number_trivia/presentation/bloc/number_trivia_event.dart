part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]) : super();
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {

  final String numberString;
  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
