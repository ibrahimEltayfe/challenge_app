import 'package:challenge_app/features/challenge_details/data/models/file_type.dart';
import 'package:flutter/material.dart';

class FileModel{
  String? name;
  FileType? type;
  IconData? icon;
  bool? canPin;

  FileModel({
    this.name,
    this.type,
    this.icon,
    this.canPin,
  });
}