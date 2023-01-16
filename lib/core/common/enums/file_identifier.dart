import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

enum FileIdentifier{
  image,
  svgImage,
  video,
  pdf,
  text,
  json,
  directory,
  notSupported,
}

extension IconsForFileType on FileIdentifier{
  IconData get getIcon{
    switch(this) {
      case FileIdentifier.image:
        return AppIcons.imageFa;
      case FileIdentifier.svgImage:
        return AppIcons.imageFa;
      case FileIdentifier.video:
        return AppIcons.videoFa;
      case FileIdentifier.pdf:
        return AppIcons.pdfFa;
      case FileIdentifier.text:
        return AppIcons.textFileFa;
      case FileIdentifier.directory:
        return AppIcons.directoryFa;
      case FileIdentifier.notSupported:
        return AppIcons.notSupportedFa;
      case FileIdentifier.json:
        return AppIcons.jsonFa;
    }
  }

  bool get canPin{
    if(this == FileIdentifier.directory || this == FileIdentifier.notSupported){
      return false;
    }

    return true;
  }
}