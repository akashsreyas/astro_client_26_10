import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallo_doctor_client/app/models/doctor_category_model.dart';
import 'package:hallo_doctor_client/app/models/doctor_model.dart';
import 'package:hallo_doctor_client/app/models/time_slot_model.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

class DoctorService {
  static Doctor? doctor;
  set currentDoctor(Doctor? doctor) => DoctorService.doctor = doctor;
  //Get list of Doctor schedule base on doctor id
  Future<List<TimeSlot>> getDoctorTimeSlot(Doctor doctor) async {
    try {
      print('doctor id : ' + doctor.doctorId!);
      //List<TimeSlot> listTimeslot = [];
      QuerySnapshot doctorScheduleRef = await FirebaseFirestore.instance
          .collection('DoctorTimeslot')
          .where('doctorId', isEqualTo: doctor.doctorId)
          .get();
      var listTimeslot = doctorScheduleRef.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['timeSlotId'] = doc.reference.id;
        TimeSlot timeSlot = TimeSlot.fromJson(data);

        return timeSlot;
      }).toList();
      print('length : ' + listTimeslot.length.toString());
      if (doctorScheduleRef.docs.isEmpty) return [];
      return listTimeslot;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

// Get doctor and all its property
  Future<Doctor> getDoctorDetail(String doctorId) async {
    var doctorSnapshot = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();
    Doctor doctor =
        Doctor.fromJson(doctorSnapshot.data() as Map<String, dynamic>);
    doctor.doctorId = doctorId;
    return doctor;
  }

  Future<List<Doctor>> getListDoctorByCategory(
      DoctorCategory doctorCategory) async {
    try {
      List<Doctor> listDoctor = [];
      var listDoctorQuery = await FirebaseFirestore.instance
          .collection('Doctors')
          .where('doctorCategory.categoryId',
              isEqualTo: doctorCategory.categoryId)
          .where('accountStatus', isEqualTo: 'active').orderBy('totalRatingCount', descending: true)
          .get();

      if (listDoctorQuery.docs.isEmpty) return [];
      var list = listDoctorQuery.docs.map((doc) {
        var data = doc.data();
        data['doctorId'] = doc.reference.id;
        Doctor doctor = Doctor.fromJson(data);
        listDoctor.add(doctor);
      }).toList();
      print('list doctor : ' + list.toString());
      return listDoctor;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Doctor>> getTopRatedDoctor({int limit = 10}) async {
    try {
      var topRatedDoctor = await FirebaseFirestore.instance
          .collection('TopRatedDoctor')
          .limit(limit)
          .get();
      List<String> listIdTopRatedDoctor = topRatedDoctor.docs.map((doc) {
        String myList =
            (doc.data()['doctorId'] as String).replaceAll(RegExp(r"\s+"), "");
        return myList;
      }).toList();

      print('list top rated : ' + listIdTopRatedDoctor.toString());
      if (listIdTopRatedDoctor.isEmpty) return [];
      var doctorRef = await FirebaseFirestore.instance
          .collection('Doctors')
          .where(FieldPath.documentId, whereIn: listIdTopRatedDoctor)
          .get();
      print('length : ' + doctorRef.docs.length.toString());
      List<Doctor> listTopRatedDoctor = doctorRef.docs.map((doc) {
        var data = doc.data();
        data['doctorId'] = doc.reference.id;
        Doctor doctor = Doctor.fromJson(data);
        return doctor;
      }).toList();
      return listTopRatedDoctor;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<Doctor>> searchDoctor(String doctorName) async {
    try {
      print('doctor name : ' + doctorName);
      if (doctorName.isEmpty) return [];
      var doctorRef = await FirebaseFirestore.instance
          .collection('Doctors')
          .where('doctorName',
              isGreaterThanOrEqualTo: doctorName,
              isLessThan: doctorName.substring(0, doctorName.length - 1) +
                  String.fromCharCode(
                      doctorName.codeUnitAt(doctorName.length - 1) + 1))
          .get();
      List<Doctor> listDoctor = doctorRef.docs.map((doc) {
        var data = doc.data();
        data['doctorId'] = doc.reference.id;
        Doctor doctor = Doctor.fromJson(data);
        return doctor;
      }).toList();
      listDoctor.removeWhere((element) => element.accountStatus != 'active');
      print('data searchnya : ' + listDoctor.toString());
      return listDoctor;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<String> getUserId(Doctor doctor) async {
    try {
      var user = await FirebaseFirestore.instance
          .collection('Users')
          .where('doctorId', isEqualTo: doctor.doctorId)
          .get();
      print('doc element' + user.docs.length.toString());
      if (user.docs.isEmpty) return '';
      return user.docs.elementAt(0).id;
    } catch (e) {
      return Future.error(e.toString());
    }
  }



  Future saveDoctorDetail(
      {required String doctorName,
        required String hospital,
        required String shortBiography,
        required String pictureUrl,
        required String doctorCategory,
        required String academicQualification,
        required String pastExperienceInCompany,
        required String pastExperienceInConsulting,
        required int basePrice,
        required String age,
        required String recognition,
        required String valueYouBring,
        bool isUpdate = false}) async {
    try {
      CollectionReference doctors =
      FirebaseFirestore.instance.collection('Doctors');
      Map<String, dynamic> doctorsData = {
        'doctorName': doctorName,
        'doctorHospital': hospital,
        'doctorBiography': shortBiography,
        'doctorPicture': pictureUrl,
        'doctorCategory': doctorCategory,
        'doctorBasePrice': basePrice,
        'accountStatus': 'nonactive',
        'academicQualification': academicQualification,
        'pastExperienceInCompany': pastExperienceInCompany,
        'pastExperienceInConsulting': pastExperienceInConsulting,
        'age': age,
        'recognition': recognition,
        'valueYouBring': valueYouBring
      };

      if (isUpdate) {
        doctorsData['updatedAt'] = FieldValue.serverTimestamp();
        await doctors.doc(DoctorService.doctor!.doctorId).update(doctorsData);
        await getDoctor(forceGet: true);
      } else {
        doctorsData['createdAt'] = FieldValue.serverTimestamp();
        doctorsData['updatedAt'] = FieldValue.serverTimestamp();
        var doctor = await doctors.add(doctorsData);
        UserService().setDoctorId(doctor.id);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

Future<Doctor?> getDoctor({bool forceGet = false}) async {
  try {
    if (DoctorService.doctor != null && forceGet == false) {
      return DoctorService.doctor;
    }

    var doctorId = await UserService().getDoctorId();
    print('doctor id : ' + doctorId);
    var doctorReference = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();
    if (!doctorReference.exists) return null;
    print('data doctor : ' + doctorReference.data().toString());
    var data = doctorReference.data() as Map<String, dynamic>;
    data['doctorId'] = doctorId;
    Doctor doctor = Doctor.fromJson(data);
    DoctorService.doctor = doctor;
    DoctorService().currentDoctor = doctor;
    return doctor;
  } catch (e) {
    return null;
  }


}
