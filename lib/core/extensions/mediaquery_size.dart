import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

extension MediaQuerySize on BuildContext{
  double get width{
    return MediaQuery.of(this).size.width;
  }
  double get height{
      return MediaQuery.of(this).size.height;
  }
}