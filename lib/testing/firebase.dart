/*import 'package:challenge_app/core/constants/end_points.dart';
import 'package:challenge_app/features/home/data/models/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDemo{
  static Future addChallenge(int itemNumber,bool isTrendy) async{
    final FirebaseFirestore _fs = FirebaseFirestore.instance;
    final doc = _fs.collection(EndPoints.challenges).doc();
   
    final challengeModel = ChallengeModel(
      points: 10,
      title: 'snowing',
      createdTime: Timestamp.fromDate(DateTime.now()),
      categoryId: 'rdlUjGCdVuaP73MAmlQW',
      contentUrl: '',
      id: doc.id,
      isTrendy: isTrendy ,
      numOfBookmarks: 3
    );

    for(int i=0;i<=itemNumber;i++){
      await _fs.collection(EndPoints.challenges).doc(doc.id).set(challengeModel.toMap());
    }
  }
}*/