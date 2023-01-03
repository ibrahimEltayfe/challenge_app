import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  final int? code;

  const Failure(this.message,{this.code});

  @override
  List<Object?> get props => [message,code];
}

class DioFailure extends Failure{
  const DioFailure(super.message, {super.code});
}

class FileFailure extends Failure{
  const FileFailure(super.message);
}

class AuthFailure extends Failure{
  const AuthFailure(super.message);
}

class NoInternetFailure extends Failure{
  const NoInternetFailure(super.message);
}

class UnExpectedFailure extends Failure{
  const UnExpectedFailure(super.message);
}

class NoUIDFailure extends Failure{
  const NoUIDFailure(super.message);
}