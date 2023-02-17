import 'package:challenge_app/core/constants/app_images.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/auth/presentation/manager/check_email_verification_provider/check_email_verification_provider.dart';
import 'package:challenge_app/features/auth/presentation/manager/send_email_verification_provider/send_email_verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/error_toast.dart';
import '../widgets/back_arrow.dart';

class EmailVerificationCheckPage extends ConsumerStatefulWidget {
  const EmailVerificationCheckPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailVerificationCheckPage> createState() => _EmailVerificationCheckPageState();
}

class _EmailVerificationCheckPageState extends ConsumerState<EmailVerificationCheckPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(sendEmailVerificationProvider.notifier).sendEmailVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BackArrow(),

              const SizedBox(height: 90,),

              Consumer(
                builder: (context, ref, child) {
                  final sendVerificationEmailState = ref.watch(sendEmailVerificationProvider);

                  ref.listen(sendEmailVerificationProvider, (previous, current) {
                    if(current is SendEmailVerificationError){
                      showErrorToast(context,current.message);
                    }
                  });

                  if(sendVerificationEmailState is SendEmailVerificationLoading){
                    return const _BuildSendEmailVerificationLoading();
                  }

                  return Column(
                    children: const[
                      _BuildMailBoxSVG(),

                      SizedBox(height: 32,),
                      _BuildCheckYourEmailText(),

                      SizedBox(height: 25,),
                      _BuildCheckValidationButton()
                    ],
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _BuildSendEmailVerificationLoading extends StatelessWidget {
  const _BuildSendEmailVerificationLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.localization.sendingVerificationEmail,
              style: context.textTheme.titleMedium,
            ),
          ),

          Center(
            child: SizedBox(
                width:22,
                height:22,
                child: CircularProgressIndicator(color: context.theme.primaryColor,strokeWidth: 3,)
            ),
          )
        ],
      ),
    );
  }
}

class _BuildCheckValidationButton extends ConsumerWidget {
  const _BuildCheckValidationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkEmailVerificationState = ref.watch(checkEmailVerificationProvider);

    ref.listen(checkEmailVerificationProvider, (previous, current) {
      if(current is CheckEmailVerificationError){
        Fluttertoast.showToast(msg: current.message);
      }else if(current is CheckEmailVerifiedSuccessfully){
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
      }
    });

    return ActionButton(
        title: context.localization.done,
        isLoading: checkEmailVerificationState is CheckEmailVerificationLoading,
        onTap: ()async{
          await ref.read(checkEmailVerificationProvider.notifier).isEmailVerified();
        }
    );
  }
}

class _BuildMailBoxSVG extends StatelessWidget {
  const _BuildMailBoxSVG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImages.mailBox,
      width: context.width*0.6,
      height: context.height*0.15,
    );
  }
}

class _BuildCheckYourEmailText extends StatelessWidget {
  const _BuildCheckYourEmailText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        context.localization.verifyEmailMessage,
        style: context.textTheme.titleLarge,textAlign: TextAlign.center,
      ),
    );
  }
}
