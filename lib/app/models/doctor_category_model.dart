// class DoctorCategory {
//   String? categoryId;
//   String? categoryName;
//   String? iconUrl;
//   DoctorCategory({this.categoryId, this.categoryName, this.iconUrl});

//   static const String _categoryName = 'categoryName';
//   static const String _iconUrl = 'iconUrl';
//   static const String _categoryId = 'categoryId';

//   factory DoctorCategory.fromJson(Map<String, dynamic> data) {
//     return DoctorCategory(
//       categoryId: data[_categoryId],
//       categoryName: data[_categoryName],
//       iconUrl: data[_iconUrl],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctor_category_model.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class DoctorCategory {
  String? id;
  @JsonKey(name: 'categoryId')
  String? categoryId;
  @JsonKey(name: 'categoryName')
  String? categoryName;
  @JsonKey(name: 'iconUrl')
  String? iconUrl;
  DoctorCategory({this.id, this.categoryId, this.categoryName, this.iconUrl});
  factory DoctorCategory.fromJson(Map<String, dynamic> json) =>
      _$DoctorCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorCategoryToJson(this);
  factory DoctorCategory.fromFirestore(DocumentSnapshot doc) =>
      DoctorCategory.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;
}
