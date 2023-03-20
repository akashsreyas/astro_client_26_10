import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'doctor_model.dart';

// class TimeSlot {
//   TimeSlot(
//       {this.timeSlotId,
//       this.timeSlot,
//       this.duration,
//       this.price,
//       this.available,
//       this.doctorid,
//       this.doctor,
//       this.purchaseTime,
//       this.status});
//   static const String _timeSlotId = 'timeSlotId';
//   static const String _timeSlot = 'timeSlot';
//   static const String _duration = 'duration';
//   static const String _price = 'price';
//   static const String _available = 'available';
//   static const String _doctorId = 'doctorId';
//   static const String _doctor = 'doctor';
//   static const String _purchaseTime = 'purchaseTime';
//   static const String _status = 'status';

//   String? timeSlotId;
//   DateTime? timeSlot;
//   int? duration;
//   int? price;
//   bool? available;
//   String? doctorid;
//   Doctor? doctor;
//   DateTime? purchaseTime;
//   String? status;

//   factory TimeSlot.fromJson(Map<String, dynamic> jsonData) {
//     return TimeSlot(
//       timeSlotId: jsonData[_timeSlotId],
//       timeSlot: (jsonData[_timeSlot] as Timestamp).toDate(),
//       duration: jsonData[_duration],
//       price: jsonData[_price],
//       available: jsonData[_available],
//       doctorid: jsonData[_doctorId],
//       doctor:
//           jsonData[_doctor] != null ? Doctor.fromJson(jsonData[_doctor]) : null,
//       purchaseTime: jsonData[_purchaseTime] != null
//           ? (jsonData[_purchaseTime] as Timestamp).toDate()
//           : null,
//       status: jsonData[_status],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'time_slot_model.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class TimeSlot {
  TimeSlot(
      {this.timeSlotId,
      this.timeSlot,
      this.duration,
      this.price,
      this.available,
      this.doctorid,
      this.doctor,
      this.purchaseTime,
      this.callststus,
      this.status});
  String? id;
  @JsonKey(name: 'timeSlotId')
  String? timeSlotId;
  @JsonKey(
      name: 'timeSlot', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? timeSlot;
  @JsonKey(name: 'duration')
  int? duration;
  @JsonKey(name: 'price')
  int? price;
  @JsonKey(name: 'available')
  bool? available;
  @JsonKey(name: 'doctorId')
  String? doctorid;
  @JsonKey(name: 'callststus')
  String? callststus;

  @JsonKey(name: 'doctor', toJson: doctorToJson)
  Doctor? doctor;
  @JsonKey(
      name: 'purchaseTime',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson)
  DateTime? purchaseTime;
  @JsonKey(name: 'status')
  String? status;
  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
  factory TimeSlot.fromFirestore(DocumentSnapshot doc) =>
      TimeSlot.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;
  static Map<String, dynamic>? doctorToJson(Doctor? doctor) => doctor?.toJson();
  static DateTime? _dateTimeFromJson(Timestamp? timestamp) =>
      timestamp?.toDate();
  static Timestamp _dateTimeToJson(DateTime? dateTime) =>
      Timestamp.fromDate(dateTime!);
}
