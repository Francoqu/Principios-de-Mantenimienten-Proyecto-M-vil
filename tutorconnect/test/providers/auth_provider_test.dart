
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tutorconnect/providers/auth_provider.dart';
import 'package:tutorconnect/services/auth_service.dart';
import 'package:tutorconnect/services/user_service.dart';
import 'package:tutorconnect/providers/user_provider.dart' as user_prov;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'auth_provider_test.mocks.dart';

// Generate mocks for AuthService and UserService
@GenerateMocks([AuthService, UserService])
void main() {
  group('Auth Providers Tests', () {
    late MockAuthService mockAuthService;
    late MockUserService mockUserService;
    late ProviderContainer container;

    setUp(() {
      mockAuthService = MockAuthService();
      mockUserService = MockUserService();

      // Create a ProviderContainer for each test.
      // Override the providers to use the mock services.
      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          user_prov.userServiceProvider.overrideWithValue(mockUserService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('signOutProvider calls authService.signOut', () async {
      // Arrange: Stub the signOut method to complete successfully.
      when(mockAuthService.signOut()).thenAnswer((_) async {});

      // Act: Read the provider. The .future will complete when the provider is done.
      await container.read(signOutProvider.future);

      // Assert: Verify that the signOut method on the mock service was called once.
      verify(mockAuthService.signOut()).called(1);
    });

    test('signInProvider calls authService.signInWithEmailPassword', () async {
      // Arrange
      final credentials = {'email': 'test@test.com', 'password': 'password'};
      // Stub the signIn method to return null, we just care if it's called.
      when(mockAuthService.signInWithEmailPassword(any, any, any))
          .thenAnswer((_) async => null);

      // Act
      await container.read(signInProvider(credentials).future);

      // Assert
      verify(mockAuthService.signInWithEmailPassword(
        credentials['email']!,
        credentials['password']!,
        mockUserService,
      )).called(1);
    });

    test('authStateProvider transitions from loading to data', () async {
      // Arrange
      // Use a stream that emits a value immediately for the test.
      when(mockAuthService.authStateChanges).thenAnswer((_) => Stream.value(null));

      // Assert initial state is loading
      expect(container.read(authStateProvider), const AsyncLoading<fb_auth.User?>());

      // Act
      // Wait for the stream to emit and the provider to process the value.
      await container.pump();

      // Assert final state is data
      expect(container.read(authStateProvider), const AsyncData<fb_auth.User?>(null));
    });
  });
}
