import 'dart:developer';

import 'package:challenge_app/config/type_def.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../data_sources/filter_remote.dart';
import '../models/filter_model.dart';

abstract class FilterRepository{
  FutureEither<List<FilterModel>> getFilters();
}

class FilterRepositoryImpl implements FilterRepository{
  final FilterRemote filterRemote;
  final NetworkInfo _connectionChecker;
  const FilterRepositoryImpl(this.filterRemote, this._connectionChecker);

  @override
  FutureEither<List<FilterModel>> getFilters() async{
    return await _handleFailures<List<FilterModel>>(() async{
      final filtersData = await filterRemote.getFilters();
      return filtersData.docs.map((e){
        return FilterModel.fromJson(e.data());
      }).toList();
    });

  }

  Future<Either<Failure, type>> _handleFailures<type>(Future<type> Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        final type results = await task();
        return Right(results);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure());
    }
  }

}