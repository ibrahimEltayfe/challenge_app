import 'package:challenge_app/core/common/no_context_localization.dart';
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
  NoInternetFailure({String? message}):super(message??noContextLocalization().noInternetError);
}

class UnExpectedFailure extends Failure{
  const UnExpectedFailure(super.message);
}

class NoUIDFailure extends Failure{
  NoUIDFailure({String? message}):super(message??noContextLocalization().noUIDError);
}

class PickFileFailure extends Failure{
  const PickFileFailure(super.message);
}

class NoDataFailure extends Failure{
  NoDataFailure({String? message}):super(message??noContextLocalization().noDataError);
}