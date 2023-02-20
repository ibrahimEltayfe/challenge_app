import '../../../../../core/common/models/challenge_model.dart';
import 'package:challenge_app/features/home/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import '../../../reusable_components/challenge_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14,),

            SearchBar(controller:_searchController),

            SizedBox(height: 14,),
            
            _BuildResults()

          ],
        ),
      ),
    );
  }
}

class _BuildResults extends StatelessWidget {
  const _BuildResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
          mainAxisSpacing:6,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ChallengeItem(
            isBookmarkActive: true,
            challengeModel: ChallengeModel(
              title: 'demo',
              id: "",
              points: 5
            ),
          );
        },
      ),
    );
  }
}
