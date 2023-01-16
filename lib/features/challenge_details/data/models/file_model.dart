import 'package:challenge_app/core/common/enums/file_identifier.dart';
import 'package:flutter/material.dart';

class FileModel{
  String? name;
  FileIdentifier? type;
  IconData? icon;
  bool? canPin;

  FileModel({
    this.name,
    this.type,
    this.icon,
    this.canPin,
  });
}