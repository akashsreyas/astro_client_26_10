import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hallo_doctor_client/app/service/doctor_service.dart';
import 'package:hallo_doctor_client/app/service/firebase_service.dart';
import 'package:hallo_doctor_client/app/service/google_signin_api.dart';
import 'package:hallo_doctor_client/app/service/user_service.dart';

import '../models/doctor_category_model.dart';
import '../models/doctor_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  DoctorCategory? doctorCategory;
  static Doctor? doctor;
  set currentDoctor(Doctor? doctor) => DoctorService.doctor = doctor;
  Future<void> loginGoogle() async {
    try {
      //Google Api  Login
      final googleUser = await GoogleSignInApi.login();
      GoogleSignInAuthentication authentication =
          await googleUser!.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseService().userSetup(user!, user.displayName!);
    } on FirebaseAuthException catch (err) {
      return Future.error(err.message!);
    }
  }

  Future login(String username, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: username, password: password);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message!);
    }
  }

  Future<void> logout() async {
    _auth.signOut();
  }

  Future register(String username, String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserService.user = result.user;
      await UserService.user!.updateDisplayName(username);
      await FirebaseService().userSetup(result.user!, username);
      //await DoctorService().saveDoctorDetail(doctorName: username, hospital: ".", shortBiography: ".", pictureUrl: ".", doctorCategory: ".", academicQualification: ".", pastExperienceInCompany: ".", pastExperienceInConsulting: ".", basePrice: 0, age: ".", recognition: ".", valueYouBring: ".");
      UserService().setDoctorId("doctor.id");


    } on FirebaseAuthException catch (e) {
      return Future.error(e.message!);
    } on SocketException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message!);
    }
  }

  /// for checking user password, ex change password, withdraw balance need passsword
  Future<bool> verifyPassword(String password) async {
    try {
      var firebaseUser = _auth.currentUser!;
      var authCredential = EmailAuthProvider.credential(
          email: firebaseUser.email!, password: password);
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredential);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }
}
