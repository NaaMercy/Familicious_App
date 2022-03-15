import 'dart:io';

import 'package:familicious_app/services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FileUploadService _fileUploadService = FileUploadService();
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  CollectionReference userCollection = _firebaseFirestore.collection('users');

  String _message = 'hello';
  bool isLoading = false;

  String get message => _message;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  //email password
  Future<bool> createNewUser({
    required String name,
    required String email,
    required String password,
    required File imageFile,
  }) async {
    bool isCreated = false;
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      String? photoUrl = await _fileUploadService.uploadFile(
          file: imageFile, userUid: userCredential.user!.uid);

      if (photoUrl != null) {
        //add user info to firestore(name, email,photo, uid, createdAt)
//Structure of collection in firebase
//users
        //documents in collection
        //user_id
        //name
        //email
        //photo
        //createdAt

        await userCollection.doc(userCredential.user!.uid).set({
          "name": name,
          "email": email,
          "picture": photoUrl,
          "createdAt": FieldValue.serverTimestamp(),
          "user_id": userCredential.user!.uid //picks the time of the server
        });

        isCreated = true;
      } else {
        setMessage("Image upload failed!");
        isLoading = false;
      }
    }).catchError((onError) {
      setMessage('$onError');
      print(onError);
      isCreated = false;
      isLoading = false;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Please check your internet connection.');
      isCreated = false;
      isLoading = false;
    });
    return isCreated;
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    bool isSuccessful = false;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
          if (userCredential.user != null) {
            isSuccessful = true;
          } else {
            isSuccessful = false;
            setMessage('Could not log you in!');
          }
        })
        .catchError((onError) {})
        .timeout(const Duration(seconds: 60), onTimeout: () {
          setMessage('Please check your internet connection.');
          isSuccessful = false;
          isLoading = false;
        });
    return isSuccessful;
  }

  Future<bool> sendResetLink(String email) async {
    bool isSent = false;
    await _firebaseAuth.sendPasswordResetEmail(email: email).then((_) {
      isSent = true;
    }).catchError((onError) {
      setMessage('$onError');
      isSent = false;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Please check your internet connection.');
      isSent = false;
    });
    return isSent;
  }
}
