import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/end_points.dart';

const responsesFetchLimit = 6;

class ChallengeResponseRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  DocumentSnapshot? lastChallengeResponse;

  Future<QuerySnapshot<Map<String, dynamic>>> getChallengeResponses(String challengeId) async{
    final QuerySnapshot<Map<String, dynamic>> responses;

    if(lastChallengeResponse == null){
      responses = await _fs.collection(EndPoints.challengeResponds)
          .where("challengeId", isEqualTo: challengeId)
          .limit(responsesFetchLimit)
          .get();
    }else{
      responses = await _fs.collection(EndPoints.challenges)
          .where("challengeId", isEqualTo: challengeId)
          .startAfterDocument(lastChallengeResponse!)
          .limit(responsesFetchLimit)
          .get();
    }

    if(responses.docs.isNotEmpty){
      lastChallengeResponse = responses.docs.last;
    }

    return responses;

  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSpecificResponseData(String challengeRespondId) async{
    return await _fs.collection(EndPoints.challengeResponds)
        .doc(challengeRespondId)
        .get();
  }

   Future getFilteredChallengeResponse(String challengeId, List<String> filterIds) async{
    final QuerySnapshot<Map<String, dynamic>> responses;

    if(lastChallengeResponse == null){
      responses = await _fs.collection(EndPoints.challengeResponds)
          .where("challengeId", isEqualTo: challengeId)
          .where('categoryIds', arrayContainsAny: filterIds)
          .limit(responsesFetchLimit)
          .get();
    }else{
      responses = await _fs.collection(EndPoints.challenges)
          .where("challengeId", isEqualTo: challengeId)
          .where('categoryIds', arrayContainsAny: filterIds)
          .startAfterDocument(lastChallengeResponse!)
          .limit(responsesFetchLimit)
          .get();
    }

    if(responses.docs.isNotEmpty){
      lastChallengeResponse = responses.docs.last;
    }

    return responses;
  }

  void reset(){
    lastChallengeResponse = null;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getGithubRepositoryData(repositoryId) async{
    return await _fs.collection(EndPoints.repositories).doc(repositoryId).get();
  }
}