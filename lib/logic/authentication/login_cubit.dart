import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/strings.dart';
import '../../data/helpers/auth_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final usernameCon = TextEditingController();
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();

  Icon hideText = const Icon(Icons.visibility_off_outlined);
  Icon showText = const Icon(Icons.visibility_outlined);
  Icon icon = const Icon(Icons.visibility_off_outlined);
  bool obscureText = true;

  bool loading = false;

  void login(BuildContext context) {
    emit(LoginLoading());
    AuthenticationHelper.instance
        .emailLogin(context, passwordCon, emailCon)
        .then((value) => BlocProvider.of<LoginCubit>(context).emitInitial());
  }

  void emitInitial() {
    emit(LoginInitial());
  }

  void openSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.signUpRoute);
  }
}
