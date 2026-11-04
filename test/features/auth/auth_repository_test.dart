import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController Riverpod Provider Tests', () {
    test('sendOtp delegates to AuthRepository and updates state', () async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenAnswer((_) async {});

      final controller = container.read(authControllerProvider.notifier);
      final success = await controller.sendOtp(
        phone: '+8801712345678',
        initialRole: UserRole.customer,
      );

      expect(success, isTrue);
      expect(container.read(authControllerProvider).isLoading, isFalse);
      expect(container.read(authControllerProvider).hasError, isFalse);
      verify(() => mockAuthRepository.signInWithOtp(
            phone: '+8801712345678',
            data: {'role': 'customer'},
          )).called(1);
    });

    test('sendOtp handles exception and transitions to AsyncError', () async {
      when(() => mockAuthRepository.signInWithOtp(
            phone: any(named: 'phone'),
            data: any(named: 'data'),
          )).thenThrow(const AuthException('SMS send quota reached'));

      final controller = container.read(authControllerProvider.notifier);
      final success = await controller.sendOtp(phone: '+8801712345678');

      expect(success, isFalse);
      expect(container.read(authControllerProvider).hasError, isTrue);
    });

    test('verifyOtp returns AuthResponse on success', () async {
      final mockAuthResponse = AuthResponse(
        session: Session(
          accessToken: 'test-token',
          tokenType: 'bearer',
          user: User(
            id: 'u-1',
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
            createdAt: '2026-11-04T00:00:00Z',
          ),
        ),
      );

      when(() => mockAuthRepository.verifyOtp(
            phone: any(named: 'phone'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => mockAuthResponse);

      final controller = container.read(authControllerProvider.notifier);
      final response = await controller.verifyOtp(
        phone: '+8801712345678',
        token: '123456',
      );

      expect(response, isNotNull);
      expect(response?.session?.accessToken, 'test-token');
      expect(container.read(authControllerProvider).isLoading, isFalse);
      expect(container.read(authControllerProvider).hasError, isFalse);
    });

    test('signOut calls repository signOut', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

      final controller = container.read(authControllerProvider.notifier);
      await controller.signOut();

      verify(() => mockAuthRepository.signOut()).called(1);
      expect(container.read(authControllerProvider).isLoading, isFalse);
      expect(container.read(authControllerProvider).hasError, isFalse);
    });
  });
}
