import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    print("GetTriviaForConcreteNumber InvalidInputFailure init");
    try {
      print("GetTriviaForConcreteNumber stringToUnsignedInteger first");
      final integer = int.parse(str);
      if (integer < 0) {
        print("GetTriviaForConcreteNumber FormatException first");
        throw const FormatException();
      }
      return Right(integer);
    } on FormatException {
      print("GetTriviaForConcreteNumber InvalidInputFailure first");
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {

}