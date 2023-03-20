// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      doctorId: json['doctorId'] as String?,
      doctorName: json['doctorName'] as String?,
      doctorPicture: json['doctorPicture'] as String?,
      doctorPrice: json['doctorBasePrice'] as int?,
      doctorShortBiography: json['doctorBiography'] as String?,
      doctorCategory: json['doctorCategory'] == null
          ? null
          : DoctorCategory.fromJson(
              json['doctorCategory'] as Map<String, dynamic>),
      doctorHospital: json['doctorHospital'] as String?,
      accountStatus: json['accountStatus'] as String?,
      doctorRating: json['doctorRating'] as double?,
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'doctorPicture': instance.doctorPicture,
      'doctorBasePrice': instance.doctorPrice,
      'doctorBiography': instance.doctorShortBiography,
      'doctorCategory': Doctor.doctorcategoryToJson(instance.doctorCategory),
      'doctorHospital': instance.doctorHospital,
      'accountStatus': instance.accountStatus,
      'doctorRating':instance.doctorRating,
    };
