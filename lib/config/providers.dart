import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../core/utils/network_checker.dart';
import '../features/auth/data/data_sources/auth_remote.dart';
import '../features/auth/data/data_sources/email_verification_remote.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/data/repositories/email_verification_repo.dart';

//! ---- Network Info ----
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final internetChecker = InternetConnectionChecker();
  return NetworkInfo(internetChecker);
});

//! ---- auth ----
final authRemoteProvider = Provider.autoDispose<AuthRemote>((ref) => AuthRemote());

final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
  final authRemoteRef = ref.read(authRemoteProvider);
  final networkInfoRef = ref.read(networkInfoProvider);

  return AuthRepositoryImpl(authRemoteRef,networkInfoRef);
});

//! ---- email verification ----
final emailVerificationRemoteProvider = Provider.autoDispose<EmailVerificationRemote>(
  (ref) => EmailVerificationRemote()
);

final emailVerificationRepositoryProvider = Provider.autoDispose<EmailVerificationRepository>((ref) {
  final emailVerificationRemoteRef = ref.read(emailVerificationRemoteProvider);
  final networkInfoRef = ref.read(networkInfoProvider);

  return EmailVerificationRepositoryImpl(emailVerificationRemoteRef,networkInfoRef);
});

