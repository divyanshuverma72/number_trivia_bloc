import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity{}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late Connectivity connectivity;

  setUp(() {
    connectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(connectivity);
  });
  
  group("is connected", () {
    test("should forward the call to DataConnectionChecker.hasConnection", () async {
      when(() => connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);

      final result = await networkInfoImpl.isConnected;

      verify(() => connectivity.checkConnectivity());
      expect(result, true);
    });
  });
}