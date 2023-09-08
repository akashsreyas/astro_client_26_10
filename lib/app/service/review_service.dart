import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/review_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

import 'doctor_service.dart';

class ReviewService {
  static Doctor? doctor;
  set currentDoctor(Doctor? doctor) => DoctorService.doctor = doctor;
  static TimeSlot? timeslot;
  Future saveReview(
      String review, double rating, TimeSlot timeSlot, User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('Review')
          .doc(timeSlot.timeSlotId)
          .set({
        'review': review,
        'rating': rating,

        'timeSlotId': timeSlot.timeSlotId,
        'userId': UserService().currentUser!.uid,
        'doctorId': timeSlot.doctorid,
        'user': {
          'displayName': UserService().currentUser!.displayName,
          'photoUrl': UserService().getProfilePicture(),
        }
      });
    } catch (e) {
      return Future.error(e.toString());
    }
    //get doctorrating

    var languageSettingVersionRef = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(timeSlot.doctorid)
        .get();
    num dr = languageSettingVersionRef.data()!['doctorRating'];


  //get totalrating from doctor

    try {
      var languageSettingVersionRef = await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(timeSlot.doctorid)
          .get();
         num tr = languageSettingVersionRef.data()!['totalRatingCount'] ;

         num a=dr*tr;
         num b=tr+1;
         num c=a+rating;
         try{
          // double avg=c/b;
           double avg=4.5;
           await FirebaseFirestore.instance
               .collection('Doctors')
               .doc(timeSlot.doctorid)
               .update({'doctorRating': avg});
           doctor?.doctorRating = avg;
         }catch(e){
           return Future.error(e.toString());
         }

      //add total rating


      try {
        num t=tr+1;
        await FirebaseFirestore.instance
            .collection('Doctors')
            .doc(timeSlot.doctorid)
            .update({'totalRatingCount': t});
             doctor?.totalRatingCount = t as int? ;
      } catch (e) {
        return Future.error(e.toString());
      }

      print(timeSlot.timeSlotId);

      DateTime now = DateTime.now();

      try {
        final post = await FirebaseFirestore.instance
            .collection('DoctorTimeslot')
            .where('timeSlot', isEqualTo: timeSlot.timeSlot)
            .limit(1)
            .get()
            .then((QuerySnapshot snapshot) {
          //Here we get the document reference and return to the post variable.
          return snapshot.docs[0].reference;
        });

        var batch = FirebaseFirestore.instance.batch();
        //Updates the field value, using post as document reference
        batch.update(post, { 'callstatus': '1' , 'endtime':now });
        batch.commit();

      } catch (e) {
        print(e);
      }


      return tr;
    } catch (e) {
      return Future.error(e);
    }



  }




  Future<List<ReviewModel>> getDoctorReview(
      {required Doctor doctor, int limit = 4}) async {
    try {
      var reviewRef = await FirebaseFirestore.instance
          .collection('Review')
          .where('doctorId', isEqualTo: doctor.doctorId)
          .limit(limit)
          .get();
      List<ReviewModel> listReview = reviewRef.docs.map((doc) {
        var data = doc.data();
        data['reviewId'] = doc.reference.id;
        ReviewModel review = ReviewModel.fromMap(data);
        return review;
      }).toList();
      return listReview;
    } catch (e) {
      return Future.error(e.toString());
    }
  }


}

