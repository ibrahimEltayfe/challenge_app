import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../core/utils/network_checker.dart';
import '../features/auth/data/data_sources/auth_remote.dart';
import '../features/auth/data/data_sources/email_verification_remote.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/data/repositories/email_verification_repo.dart';
import '../features/auth/data/data_sources/reset_password_remote.dart';
import '../features/auth/data/repositories/reset_password_repo.dart';
import '../features/challenge_details/data/data_sources/challenge_details_remote.dart';
import '../features/challenge_details/data/data_sources/challenge_response_remote.dart';
import '../features/challenge_details/data/data_sources/filter_remote.dart';
import '../features/challenge_details/data/repositories/challenge_details_repo.dart';
import '../features/challenge_details/data/repositories/challenge_response_repo.dart';
import '../features/challenge_details/data/repositories/filter_repo.dart';
import '../features/challenge_details/data/data_sources/response_user_data_remote.dart';
import '../features/challenge_details/data/repositories/response_user_data_repo.dart';
import '../features/home/data/data_sources/challenges_remote.dart';
import '../features/home/data/data_sources/user_bookmarks_manager_remote.dart';
import '../features/home/data/data_sources/user_data_remote.dart';
import '../features/home/data/repositories/challenges_repo.dart';
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
  final challengeRemoteProvider = Provider.autoDispose<ChallengesRemote>((ref) => ChallengesRemote());

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

//! Challenge Details
  //! ---- challenge_details ----
  final challengeDetailsRemoteProvider = Provider.autoDispose<ChallengeDetailsRemote>((ref) => ChallengeDetailsRemote());

  final challengeDetailsRepositoryProvider = Provider.autoDispose<ChallengeDetailsRepository>((ref) {
    final challengeDetailsRemoteRef = ref.read(challengeDetailsRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return ChallengeDetailsRepositoryImpl(challengeDetailsRemoteRef,networkInfoRef);
  });

  //! ---- filter ----
  final filterRemoteProvider = Provider.autoDispose<FilterRemote>((ref) => FilterRemote());

  final filterRepositoryProvider = Provider.autoDispose<FilterRepository>((ref) {
    final filterRemoteRef = ref.read(filterRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return FilterRepositoryImpl(filterRemoteRef,networkInfoRef);
  });

  //! ---- challenge_response ----
  final challengeResponseRemoteProvider = Provider.autoDispose<ChallengeResponseRemote>((ref) => ChallengeResponseRemote());

  final challengeResponseRepositoryProvider = Provider.autoDispose<ChallengeResponseRepository>((ref) {
    final challengeResponseRemoteRef = ref.read(challengeResponseRemoteProvider);
    final responseUserDataRepositoryRef = ref.read(responseUserDataRepositoryProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return ChallengeResponseRepositoryImpl(challengeResponseRemoteRef,responseUserDataRepositoryRef,networkInfoRef);
  });

  //! ---- response_user_data ----
  final responseUserDataRemoteProvider = Provider.autoDispose<ResponseUserDataRemote>((ref) => ResponseUserDataRemote());

  final responseUserDataRepositoryProvider = Provider.autoDispose<ResponseUserDataRepository>((ref) {
    final responseUserDataRemoteRef = ref.read(responseUserDataRemoteProvider);
    final networkInfoRef = ref.read(networkInfoProvider);

    return ResponseUserDataRepositoryImpl(responseUserDataRemoteRef,networkInfoRef);
  });
