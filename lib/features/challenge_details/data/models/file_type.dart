import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

enum FileType{
  image,
  video,
  pdf,
  text,
  json,
  directory,
  notSupported
}

extension IconsForFileType on FileType{
  IconData get getIcon{
    switch(this) {
      case FileType.image:
        return AppIcons.imageFa;
      case FileType.video:
        return AppIcons.videoFa;
      case FileType.pdf:
        return AppIcons.pdfFa;
      case FileType.text:
        return AppIcons.textFileFa;
      case FileType.directory:
        return AppIcons.directoryFa;
      case FileType.notSupported:
        return AppIcons.notSupportedFa;
      case FileType.json:
        return AppIcons.jsonFa;
    }
  }

  bool get canPin{
    if(this == FileType.directory || this == FileType.notSupported){
      return false;
    }

    return true;
  }
}