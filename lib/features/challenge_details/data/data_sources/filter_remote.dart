import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getFilters() async{
   return _fs.collection(EndPoints.categories).get();
  }


}