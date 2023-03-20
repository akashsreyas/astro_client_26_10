// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorCategory _$DoctorCategoryFromJson(Map<String, dynamic> json) =>
    DoctorCategory(
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$DoctorCategoryToJson(DoctorCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'iconUrl': instance.iconUrl,
    };
