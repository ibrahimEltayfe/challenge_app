import 'package:challenge_app/features/challenge_details/data/models/file_type.dart';
import 'package:flutter/material.dart';

class FileModel{
  String? fileName;
  FileType? fileType;
  IconData? fileIcon;
  bool? canPin;

  FileModel({
    this.fileName,
    this.fileType,
    this.fileIcon,
    this.canPin,
  });
}