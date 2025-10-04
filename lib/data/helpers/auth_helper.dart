// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/strings.dart';
import '../../presentation/widgets/toast.dart';
import '../models/user_model.dart';

class AuthenticationHelper {
  AuthenticationHelper._privateConstructor();

  static final AuthenticationHelper _instance =
      AuthenticationHelper._privateConstructor();

  static AuthenticationHelper get instance => _instance;
  final auth = FirebaseAuth.instance;

  Future<void> emailLogin(String password, String email) async {
    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> emailSignUp(
    String password,
    String email,
    String username,
  ) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    userCredential.user!.updateDisplayName(username.trim());
    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  void logout() => auth.signOut();

  Future<UserModel> getUserCredential() async {
    UserModel user = UserModel(
      uid: auth.currentUser!.uid,
      name: auth.currentUser!.displayName!,
      email: auth.currentUser!.email!,
    );
    return user;
  }
}
