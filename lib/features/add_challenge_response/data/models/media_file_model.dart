import 'package:challenge_app/core/common/enums/file_identifier.dart';

class MediaFileModel{
  FileIdentifier? type;
  final String path;

  MediaFileModel({
    this.type,
    required this.path,
  });
}