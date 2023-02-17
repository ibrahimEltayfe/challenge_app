import 'package:flutter/material.dart';

extension SliverConvertor on Widget{
  Widget get toSliver{
    return SliverToBoxAdapter(
      child: this
    );
  }
}