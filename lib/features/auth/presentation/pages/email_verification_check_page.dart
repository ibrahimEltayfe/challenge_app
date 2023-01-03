import 'package:challenge_app/core/constants/app_images.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../reusable_components/action_button.dart';
import '../widgets/back_arrow.dart';

class EmailVerificationCheckPage extends StatelessWidget {
  const EmailVerificationCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackArrow(),

              SizedBox(height: 90,),
              SvgPicture.asset(
                AppImages.mailBox,
                width: context.width*0.6,
                height: context.height*0.15,
              ),

              SizedBox(height: 32,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  context.localization.verifyEmailMessage,
                 style: context.textTheme.titleLarge,textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 25,),
              ActionButton(
                  title: context.localization.done,
                  onTap: (){
                    //todo:check email verification

                    //if verified
                    Navigator.pushNamed(context,AppRoutes.editProfileRoute);
                  }

              )


            ],
          ),
        ),
      ),

    );
  }

}
