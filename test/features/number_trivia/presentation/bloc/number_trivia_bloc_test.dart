import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}
class MockInputConverter extends Mock implements InputConverter {}

void main () {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(getConcreteNumberTrivia: mockGetConcreteNumberTrivia, getRandomNumberTrivia: mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
  });

  test("initialState should be empty", () {
    expect(numberTriviaBloc.initialState, Empty());
  });

  group("GetTriviaForConcreteNumber", () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    registerFallbackValue(const Params(number: tNumberParsed));

    void setUpMockInputConverterSuccess() => when(() => mockInputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(tNumberParsed));

    test("should call the InputConverter to validate and convert the string to an unsigned integer ", ()  async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockInputConverter.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test(
      'should emit [Error] when the input is invalid',
          () async {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(numberTriviaBloc.state, emitsInOrder(expected));
        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(() => mockGetConcreteNumberTrivia(any()));
        // assert
        verify(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    test("should emit [Loading, Loaded] when data is gotten successfully", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((invocation) async => const Right(tNumberTrivia));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia)
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((invocation) async => Left(ServerFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test("should emit [Loading, Error] with a proper message for the error when getting data fails", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((invocation) async => Left(CacheFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group("GetTriviaForRandomNumber", () {
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);
    registerFallbackValue(NoParams());

    test(
      'should get data from the concrete use case',
          () async {
        // arrange
        when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        numberTriviaBloc.add(GetTriviaForRandomNumber());
        await untilCalled(() => mockGetRandomNumberTrivia(any()));
        // assert
        verify(() => mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test("should emit [Loading, Loaded] when data is gotten successfully", () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((invocation) async => const Right(tNumberTrivia));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia)
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] when getting data fails", () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] with a proper message for the error when getting data fails", () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any())).thenAnswer((invocation) async => Left(CacheFailure()));

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];

      expectLater(numberTriviaBloc.state, emitsInOrder(expected));

      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });
}