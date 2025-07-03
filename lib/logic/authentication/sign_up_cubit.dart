// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:testt/logic/authentication/sign_up_state.dart';
import 'package:meta/meta.dart';

import '../../constants/strings.dart';
import '../../data/helpers/auth_helper.dart';
import '../../presentation/widgets/toast.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final userNameCon = TextEditingController();
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  final passwordConfirmCon = TextEditingController();

  late Icon icon = const Icon(Icons.visibility_off_outlined);
  late Icon confIcon = const Icon(Icons.visibility_off_outlined);
  bool obscureText = true;
  bool confirmObscureText = true;

  Future<void> signUp(BuildContext context) async {
    emit(SignUpLoading());
    if (passwordCon.text.isEmpty ||
        emailCon.text.isEmpty ||
        passwordConfirmCon.text.isEmpty ||
        userNameCon.text.isEmpty) {
      toastBuilder("Fill all the fields", context);
    } else if (!EmailValidator.validate(emailCon.text.trim())) {
      toastBuilder("Incorrect email format", context);
    } else {
      AuthenticationHelper.instance
          .emailSignUp(
            context,
            passwordCon.text,
            emailCon.text,
            passwordConfirmCon.text,
            userNameCon.text,
          )
          .then((value) => emitInitial());
    }
    emitInitial();
  }

  void emitInitial() {
    emit(SignUpInitial());
  }

  void openLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}
