import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String path;
  const ImageDisplay({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.contain,
    );
  }
}