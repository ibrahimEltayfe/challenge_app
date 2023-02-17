import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../core/utils/network_checker.dart';
import '../features/auth/data/data_sources/auth_remote.dart';
import '../features/auth/data/data_sources/email_verification_remote.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/data/repositories/email_verification_repo.dart';
import '../features/auth/data/data_sources/reset_password_remote.dart';
import '../features/auth/data/repositories/reset_password_repo.dart';
import '../features/home/data/data_sources/challenge_remote.dart';
import '../features/home/data/data_sources/user_bookmarks_manager_remote.dart';
import '../features/home/data/data_sources/user_data_remote.dart';
import '../features/home/data/repositories/challenge_repo.dart';
import '../features/home/data/repositories/user_bookmarks_manager_repo.dart';
import '../features/home/data/repositories/user_data_repo.dart';

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

//! ---- reset_password ----
final resetPasswordRemoteProvider = Provider.autoDispose<ResetPasswordRemote>((ref) => ResetPasswordRemote());

final resetPasswordRepositoryProvider = Provider.autoDispose<ResetPasswordRepository>((ref) {
  final resetPasswordRemoteRef = ref.read(resetPasswordRemoteProvider);
  final networkInfoRef = ref.read(networkInfoProvider);

  return ResetPasswordRepositoryImpl(resetPasswordRemoteRef,networkInfoRef);
});

//! ---- Home ----
  //! ---- User Data ----
  final userDataRemoteProvider = Provider.autoDispose<UserDataRemote>((ref) => UserDataRemote());

  final userDataRepositoryProvider = Provider.autoDispose<UserDataRepository>((ref) {
    final userDataRemoteRef = ref.read(userDataRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return UserDataRepositoryImpl(userDataRemoteRef,networkInfoRef);
  });

  //! ---- challenge_data ----
  final challengeRemoteProvider = Provider.autoDispose<ChallengeRemote>((ref) => ChallengeRemote());

  final challengeRepositoryProvider = Provider.autoDispose<ChallengeRepository>((ref) {
    final challengeRemoteRef = ref.read(challengeRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return ChallengeRepositoryImpl(challengeRemoteRef,networkInfoRef);
  });

  //! ---- user_bookmarks_manager ----
  final userBookmarksManagerRemoteProvider = Provider.autoDispose<UserBookmarksManagerRemote>((ref) => UserBookmarksManagerRemote());

  final userBookmarksManagerRepositoryProvider = Provider.autoDispose<UserBookmarksManagerRepository>((ref) {
    final userBookmarksManagerRemoteRef = ref.read(userBookmarksManagerRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return UserBookmarksManagerRepositoryImpl(userBookmarksManagerRemoteRef,networkInfoRef);
  });