import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';
import '../../../../core/constants/end_points.dart';

const int docsFetchLimit = 5;

class ChallengeRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  DocumentSnapshot? _lastTrendyChallenge;
  DocumentSnapshot? _lastNewChallenge;
  DocumentSnapshot? _lastRegularChallenge;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchTrendyChallenges() async{
    final QuerySnapshot<Map<String, dynamic>> challenges;

    if(_lastTrendyChallenge == null){
      challenges = await _fs.collection(EndPoints.challenges)
          .where('isTrendy',isEqualTo: true)
          .limit(docsFetchLimit)
          .get();
    }else{
      challenges = await _fs.collection(EndPoints.challenges)
          .where('isTrendy',isEqualTo: true)
          .startAfterDocument(_lastTrendyChallenge!)
          .limit(docsFetchLimit)
          .get();
    }

    if(challenges.docs.isNotEmpty){
      _lastTrendyChallenge = challenges.docs.last;
    }

    return challenges;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchNewChallenges() async{
    final currentDate = await NTP.now();
    final Timestamp maxDuration = Timestamp.fromDate(currentDate.subtract(const Duration(days: 3)));

    final QuerySnapshot<Map<String, dynamic>> challenges;

    if(_lastNewChallenge == null){
      challenges =  await _fs.collection(EndPoints.challenges)
          .orderBy("createdTime",descending: true)
          .where("createdTime",isGreaterThanOrEqualTo: maxDuration)
          .limit(docsFetchLimit)
          .get();
    }else{
      challenges = await _fs.collection(EndPoints.challenges)
          .orderBy("createdTime",descending: true)
          .where("createdTime",isGreaterThanOrEqualTo: maxDuration)
          .startAfterDocument(_lastNewChallenge!)
          .limit(docsFetchLimit)
          .get();
    }

    if(challenges.docs.isNotEmpty){
      _lastNewChallenge = challenges.docs.last;
    }

    return challenges;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchRegularChallenges() async{
    final QuerySnapshot<Map<String, dynamic>> challenges;

    if(_lastRegularChallenge == null){
      challenges = await _fs.collection(EndPoints.challenges)
          .where('isTrendy',isEqualTo: false)
          .limit(docsFetchLimit)
          .get();
    }else{
      challenges = await _fs.collection(EndPoints.challenges)
          .where('isTrendy',isEqualTo: false)
          .startAfterDocument(_lastRegularChallenge!)
          .limit(docsFetchLimit)
          .get();
    }

    if(challenges.docs.isNotEmpty){
      _lastRegularChallenge = challenges.docs.last;
    }

    return challenges;
  }

  void resetPagination(){
    _lastTrendyChallenge = null;
    _lastNewChallenge = null;
    _lastRegularChallenge = null;
  }

}