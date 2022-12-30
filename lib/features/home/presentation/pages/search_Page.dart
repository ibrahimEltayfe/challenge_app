import 'package:challenge_app/features/home/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15,),
            SearchBar()
          ],

        ),
      ),
    );
  }
}
