import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'faq_model.g.dart';

@JsonSerializable(ignoreUnannotated: true)
class FaqModel {
  String? id;
  @JsonKey(name: 'question')
  String? question;
  @JsonKey(name: 'answer')
  String? answer;
  FaqModel({this.id, this.question, this.answer});
  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);
  Map<String, dynamic> toJson() => _$FaqModelToJson(this);
  factory FaqModel.fromFirestore(DocumentSnapshot doc) =>
      FaqModel.fromJson(doc.data()! as Map<String, dynamic>)..id = doc.id;
}
