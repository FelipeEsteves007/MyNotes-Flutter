import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {
  group('Mock Authenticaion', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider._isInitialzied, false);
    });
    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('User should be delegate to logIn function', () async {
      expect(
        () => provider.logIn(email: 'foo@bar.com', password: 'foobar'),
        throwsA(isA<InvalidEmailException>()),
      );
    });

    test('test weak password', () async {
      expect(
        () => provider.logIn(email: 'valid@.com', password: 'foobar'),
        throwsA(isA<WeakpeakException>()),
      );
    });

    test('Create a user', () async {
      final userCreated = await provider.createUser(
        email: 'valid@.com',
        password: 'validPass',
      );
      expect(provider.currentUser, userCreated);
      expect(userCreated.isEmailVerified, false);
    });

    test('User verify email', () async {
      await provider.sendEmailVerification();
      final emailUser = provider.currentUser;
      expect(emailUser, isNotNull);
      expect(emailUser?.isEmailVerified, true);
    });

    test('User should be logOut and logIn', () async {
      await provider.logOut();
      await provider.logIn(email: 'valid@.com', password: 'validPass');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialzied = false;
  bool get isInitialized => _isInitialzied;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialzied = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw InvalidEmailException();
    if (password == 'foobar') throw WeakpeakException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(_user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
