import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: const Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 15,top: 16),
          child: Icon(
            AppIcons.leftBackArrowFa,
            size: 27,
          ),
        ),
      ),
    );
  }
}
