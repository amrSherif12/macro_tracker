import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/strings.dart';
import '../../data/helpers/auth_helper.dart';
import '../../presentation/widgets/toast.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool loading = false;
  bool obscureText = true;

  Future<void> login(
    BuildContext context,
    String password,
    String email,
  ) async {
    if (password.isEmpty || email.isEmpty) {
      toastBuilder("Fill all the fields", context);
    } else if (!EmailValidator.validate(email.trim())) {
      toastBuilder("Incorrect email format", context);
    } else {
      emit(LoginLoading());
      try {
        await AuthenticationHelper.instance.emailLogin(password, email);
        emit(LoginInitial());
        toastBuilder("Signed in successfully", context);
        Navigator.pushReplacementNamed(context, Routes.navigationRoute);
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
}
