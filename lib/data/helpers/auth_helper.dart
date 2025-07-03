// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> emailLogin(
    BuildContext context,
    TextEditingController passwordCon,
    TextEditingController emailCon,
  ) async {
    if (passwordCon.text.isEmpty || emailCon.text.isEmpty) {
      toastBuilder("Fill all the fields", context);
    } else if (!EmailValidator.validate(emailCon.text.trim())) {
      toastBuilder("Incorrect email format", context);
    } else {
      try {
        await auth
            .signInWithEmailAndPassword(
              email: emailCon.text.trim(),
              password: passwordCon.text.trim(),
            )
            .then((value) async {
              toastBuilder("Signed in successfully", context);

              Navigator.pushReplacementNamed(context, Routes.navigationRoute);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          toastBuilder("User not found", context);
        } else if (e.code == 'invalid-credential') {
          toastBuilder("Wrong password or email", context);
        } else if (e.code == 'network-request-failed') {
          toastBuilder("No internet connection", context);
        } else if (e.code == 'too-many-requests') {
          toastBuilder("Too many attempts please try later", context);
        }
      }
    }
  }

  Future<void> emailSignUp(
    BuildContext context,
    String passwordCon,
    String emailCon,
    String passwordConfirmCon,
    String userName,
  ) async {
    if (passwordCon.trim() == passwordConfirmCon.trim()) {
      try {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(
              email: emailCon.trim(),
              password: passwordCon.trim(),
            );
        userCredential.user!.updateDisplayName(userName.trim());
        await auth
            .signInWithEmailAndPassword(
              email: emailCon.trim(),
              password: passwordCon.trim(),
            )
            .then((value) async {
              toastBuilder("Account created successfully", context);

              Navigator.pushReplacementNamed(context, Routes.navigationRoute);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          toastBuilder("Password can't be less than 6 characters", context);
        } else if (e.code == 'email-already-in-use') {
          toastBuilder("Email already in use", context);
        }
      } catch (e) {
        toastBuilder("Unknown error occurred", context);
      }
    } else if (passwordCon.trim() != passwordConfirmCon.trim()) {
      toastBuilder(
        "The password confirmation doesn't match the password",
        context,
      );
    }
  }

  void logout(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    auth.signOut();

    await pref.setString("userName", "");
    await pref.setString("userID", "");
    await pref.setString("email", "");

    Navigator.pushReplacementNamed(context, Routes.welcomeRoute);
  }

  Future<UserModel> getUserCredential() async {
    UserModel user = UserModel(
      uid: auth.currentUser!.uid,
      name: auth.currentUser!.displayName!,
      email: auth.currentUser!.email!,
    );

    return user;
  }
}
