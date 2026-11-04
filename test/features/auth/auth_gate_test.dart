import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaajlagbe/core/constants/app_constants.dart';
import 'package:kaajlagbe/features/auth/domain/auth_repository.dart';
import 'package:kaajlagbe/features/auth/domain/user_profile.dart';
import 'package:kaajlagbe/features/auth/presentation/auth_providers.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/account_status_screen.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/auth_gate.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/home_screen_placeholder.dart';
import 'package:kaajlagbe/features/auth/presentation/screens/phone_login_screen.dart';
import 'package:kaajlagbe/l10n/app_localizations.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}
class MockSession extends Mock implements Session {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget buildTestWidget({
    Session? session,
    User? user,
    UserProfile? profile,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentSessionProvider.overrideWithValue(session),
        currentAuthUserProvider.overrideWithValue(user),
        currentUserProfileProvider.overrideWith((ref) => Stream.value(profile)),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('bn'),
        home: AuthGate(),
      ),
    );
  }

  testWidgets('Unauthenticated user is routed to PhoneLoginScreen', (tester) async {
    await tester.pumpWidget(buildTestWidget(session: null, user: null));
    await tester.pumpAndSettle();

    expect(find.byType(PhoneLoginScreen), findsOneWidget);
  });

  testWidgets('Authenticated approved user is routed to HomeScreenPlaceholder', (tester) async {
    final mockUser = MockUser();
    when(() => mockUser.id).thenReturn('u-123');
    when(() => mockUser.userMetadata).thenReturn({'role': 'customer'});

    final mockSession = MockSession();
    when(() => mockSession.user).thenReturn(mockUser);

    final approvedProfile = UserProfile(
      id: 'u-123',
      fullName: 'Habibur Rahman',
      phone: '+8801700000000',
      role: UserRole.customer,
      accountStatus: AccountStatus.approved,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      buildTestWidget(
        session: mockSession,
        user: mockUser,
        profile: approvedProfile,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreenPlaceholder), findsOneWidget);
    expect(find.textContaining('Habibur Rahman'), findsOneWidget);
  });

  testWidgets('Authenticated pending labour is routed to AccountStatusScreen', (tester) async {
    final mockUser = MockUser();
    when(() => mockUser.id).thenReturn('u-456');
    when(() => mockUser.userMetadata).thenReturn({'role': 'labour'});

    final mockSession = MockSession();
    when(() => mockSession.user).thenReturn(mockUser);

    final pendingProfile = UserProfile(
      id: 'u-456',
      fullName: 'Jamal Plumber',
      phone: '+8801800000000',
      role: UserRole.labour,
      accountStatus: AccountStatus.pendingVerification,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      buildTestWidget(
        session: mockSession,
        user: mockUser,
        profile: pendingProfile,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AccountStatusScreen), findsOneWidget);
    expect(find.textContaining('যাচাইকরণ প্রক্রিয়াধীন'), findsOneWidget);
  });
}
