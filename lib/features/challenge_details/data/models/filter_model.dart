import 'package:equatable/equatable.dart';

class FilterModel extends Equatable{
  String? name;
  String? id;
  String? category;

  FilterModel({this.name,this.id,this.category});

  factory FilterModel.fromJson(Map<String,dynamic> data){
    return FilterModel(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      category: data['category'] ?? ''
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}