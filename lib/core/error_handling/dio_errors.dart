import 'package:dio/dio.dart';
import 'failures.dart';

Failure handleDioErrors(DioError error){
  switch(error.type){
    case DioErrorType.connectTimeout:
      return DioErrorTypes.CONNECTION_TIMEOUT.getFailure();

    case DioErrorType.sendTimeout:
      return DioErrorTypes.SEND_TIMEOUT.getFailure();

    case DioErrorType.receiveTimeout:
      return DioErrorTypes.RECEIVE_TIMEOUT.getFailure();

    case DioErrorType.response:
      if(error.response != null){
        if(error.response!.statusCode != null){
          switch (error.response!.statusCode) {
            case ResponseCode.BAD_REQUEST:
              return DioErrorTypes.BAD_REQUEST.getFailure();

            case ResponseCode.UN_AUTHORIZED:
              return DioErrorTypes.UN_AUTHORIZED.getFailure();

            case ResponseCode.NOT_FOUND:
              return DioErrorTypes.NOT_FOUND.getFailure();

            case ResponseCode.SEND_TIMEOUT:
              return DioErrorTypes.SEND_TIMEOUT.getFailure();

            case ResponseCode.INTERNAL_SERVER_ERROR:
              return DioErrorTypes.INTERNAL_SERVER_ERROR.getFailure();

            default:
              return DioErrorTypes.DEFAULT.getFailure();
          }
        }
      }
      return DioErrorTypes.DEFAULT.getFailure();

    case DioErrorType.cancel:
      return DioErrorTypes.CANCEL.getFailure();

    case DioErrorType.other:
      return DioErrorTypes.DEFAULT.getFailure();

  }
}

enum DioErrorTypes{
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  UN_AUTHORIZED,
  FORBIDDEN,
  REQUEST_TIMEOUT,
  INTERNAL_SERVER_ERROR,
  NOT_FOUND,

  CONNECTION_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

class ResponseCode{
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; //success with no data (no content)
  static const int BAD_REQUEST = 400; // API rejected request
  static const int UN_AUTHORIZED = 401; // un authorized user
  static const int FORBIDDEN = 403; // API rejected request
  static const int NOT_FOUND = 404; // crash in server side
  static const int REQUEST_TIMEOUT= 408;
  static const int INTERNAL_SERVER_ERROR =500; // crash in server side

// Local status code (before sending to api)
  static const int CONNECTION_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int SEND_TIMEOUT= 408;
  static const int RECEIVE_TIMEOUT = -3;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage{
  static const String SUCCESS ="success" ; // success with data
  static const String NO_CONTENT = "success" ; // success with no data (no content)
  static const String BAD_REQUEST = "bad request, Try again later"; // failure, API rejected request
  static const String UN_AUTHORIZED = "user is un authorized" ; // failure, user is not authorised
  static const String FORBIDDEN = "server rejected the request, Try again later" ; // failure, API rejected request
  static const String REQUEST_TIMEOUT = "time out, please try again later" ;
  static const String INTERNAL_SERVER_ERROR = "some thing went wrong, please try again later"; // failure, crash in server side
  static const String NOT_FOUND = "page not found, please try again later";

  // Local status code (before sending to api)
  static const String CONNECTION_TIMEOUT = "time out, please try again";
  static const String CANCEL = "request was cancelled, please try again";
  static const String RECEIVE_TIMEOUT = "time out , please try again";
  static const String SEND_TIMEOUT = "Time out error, please try again";
  static const String CACHE_ERROR =  "cache error, please try again";
  static const String NO_INTERNET_CONNECTION = "PLease check your internet connection";
  static const String DEFAULT ="some thing went wrong, Try again later ";
}

extension ErrorHandling on DioErrorTypes{
  Failure getFailure(){
    switch(this){
      case DioErrorTypes.SUCCESS:
        return const DioFailure(ResponseMessage.SUCCESS, code:ResponseCode.SUCCESS);

      case DioErrorTypes.NO_CONTENT:
        return const DioFailure(ResponseMessage.NO_CONTENT,code: ResponseCode.NO_CONTENT);

      case DioErrorTypes.BAD_REQUEST:
        return const DioFailure(ResponseMessage.BAD_REQUEST,code: ResponseCode.BAD_REQUEST);

      case DioErrorTypes.UN_AUTHORIZED:
        return const DioFailure(ResponseMessage.UN_AUTHORIZED, code:ResponseCode.UN_AUTHORIZED);

      case DioErrorTypes.FORBIDDEN:
        return const DioFailure(ResponseMessage.FORBIDDEN,code: ResponseCode.FORBIDDEN);

      case DioErrorTypes.REQUEST_TIMEOUT:
        return const DioFailure(ResponseMessage.REQUEST_TIMEOUT,code: ResponseCode.REQUEST_TIMEOUT);

      case DioErrorTypes.INTERNAL_SERVER_ERROR:
        return const DioFailure(ResponseMessage.INTERNAL_SERVER_ERROR,code: ResponseCode.INTERNAL_SERVER_ERROR);

      case DioErrorTypes.NOT_FOUND:
        return const DioFailure(ResponseMessage.NOT_FOUND,code: ResponseCode.NOT_FOUND);

      case DioErrorTypes.CONNECTION_TIMEOUT:
        return const DioFailure(ResponseMessage.CONNECTION_TIMEOUT,code: ResponseCode.CONNECTION_TIMEOUT);

      case DioErrorTypes.CANCEL:
        return const DioFailure(ResponseMessage.CANCEL,code: ResponseCode.CANCEL);

      case DioErrorTypes.RECEIVE_TIMEOUT:
        return const DioFailure(ResponseMessage.RECEIVE_TIMEOUT,code: ResponseCode.RECEIVE_TIMEOUT);

      case DioErrorTypes.SEND_TIMEOUT:
        return const DioFailure(ResponseMessage.SEND_TIMEOUT,code: ResponseCode.SEND_TIMEOUT);

      case DioErrorTypes.CACHE_ERROR:
        return const DioFailure(ResponseMessage.CACHE_ERROR,code: ResponseCode.CACHE_ERROR);

      case DioErrorTypes.NO_INTERNET_CONNECTION:
        return const DioFailure(ResponseMessage.NO_INTERNET_CONNECTION,code: ResponseCode.NO_INTERNET_CONNECTION);

      case DioErrorTypes.DEFAULT:
        return const DioFailure(ResponseMessage.DEFAULT,code: ResponseCode.DEFAULT);
  }
  }
}

