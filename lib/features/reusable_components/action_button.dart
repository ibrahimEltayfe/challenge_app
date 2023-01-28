import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double cornerRadius;
  final bool isLoading;
  const ActionButton({
    this.cornerRadius = 8,
    this.width,
    this.height,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    Key? key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7
              )
          ),
          fixedSize: MaterialStatePropertyAll<Size>(
              Size(
                  width??338,
                  height??60
              )
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(context.theme.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              )
          ),
        ),
        onPressed: onTap,
        child: isLoading
         ?Lottie.asset("assets/lottie/loading.json",fit: BoxFit.contain)
         :FittedBox(
          child: Text(title,style: context.textTheme.headlineSmall,),
        )
    );
  }
}
