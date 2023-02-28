import 'package:challenge_app/features/challenge_details/data/models/github_repository_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/github_provider/github_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/specific_challenge_response_provider/specific_challenge_response_provider.dart';
import 'package:challenge_app/features/reusable_components/back_button_shadow_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/code_explorer.dart';
import '../widgets/lottie_widget.dart';

class RepositoryFileExplorerPage extends ConsumerWidget {
  const RepositoryFileExplorerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              const BackButtonBox(),

              const SizedBox(height: 15,),

              Consumer(
                builder: (context, ref, child){
                  final githubRef = ref.watch(githubProvider);
                  
                  if(githubRef is GithubError){
                    return LottieWidget(
                      message: githubRef.message,
                      lottiePath:'assets/lottie/github_download_error.json',
                      repeat: false,
                    );
                  }else if(githubRef is GithubLoading){
                    return const LottieWidget(
                      message: 'Downloading Repository Files..',
                      lottiePath: 'assets/lottie/github-loading.json',
                    );
                  }else if(githubRef is GithubDataFetched){
                    return const CodeExplorer();
                  }
                  
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
