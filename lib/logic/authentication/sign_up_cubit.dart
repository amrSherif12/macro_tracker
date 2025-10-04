// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/logic/authentication/sign_up_state.dart';

import '../../constants/strings.dart';
import '../../data/helpers/auth_helper.dart';
import '../../presentation/widgets/toast.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  late Icon icon = const Icon(Icons.visibility_off_outlined);
  late Icon confIcon = const Icon(Icons.visibility_off_outlined);
  bool obscureText = true;
  bool confirmObscureText = true;

  Future<void> signUp(
    BuildContext context,
    String password,
    String email,
    String confirmPass,
    String username,
  ) async {
    emit(SignUpLoading());
    if (password.isEmpty ||
        email.isEmpty ||
        confirmPass.isEmpty ||
        username.isEmpty) {
      toastBuilder("Fill all the fields", context);
    } else if (!EmailValidator.validate(email.trim())) {
      toastBuilder("Incorrect email format", context);
    } else {
      if (password.trim() == confirmPass.trim()) {
        try {
          emit(SignUpLoading());
          await AuthenticationHelper.instance.emailSignUp(
            password,
            email,
            username,
          );
          toastBuilder("Account created successfully", context);
          Navigator.pushReplacementNamed(context, Routes.navigationRoute);
          emit(SignUpInitial());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            toastBuilder("Password can't be less than 6 characters", context);
          } else if (e.code == 'email-already-in-use') {
            toastBuilder("Email already in use", context);
          }
        } catch (e) {
          toastBuilder("Unknown error occurred", context);
        }
      } else if (password.trim() != confirmPass.trim()) {
        toastBuilder(
          "The password confirmation doesn't match the password",
          context,
        );
      }
    }
    emit(SignUpInitial());
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();

    AuthenticationHelper.instance.logout();

    await pref.setString("userName", "");
    await pref.setString("userID", "");
    await pref.setString("email", "");
  }
}
