import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/helpers/auth_helper.dart';
import '../../../logic/authentication/sign_up_cubit.dart';
import '../../../logic/authentication/sign_up_state.dart';
import '../../widgets/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
        statusBarColor: ConstColors.main));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstColors.main,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ConstColors.main,
              ConstColors.main,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                FadeInDown(
                  from: 30,
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                        fontFamily: 'F', fontSize: 35, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FadeInDown(
                        from: 30,
                        delay: const Duration(milliseconds: 70),
                        child: TextFieldBuilder(
                          controller:
                              BlocProvider.of<SignUpCubit>(context).userNameCon,
                          label: "User name",
                          hint: "Enter your name",
                          iconData: Icons.person,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        from: 30,
                        delay: const Duration(milliseconds: 140),
                        child: TextFieldBuilder(
                          controller:
                              BlocProvider.of<SignUpCubit>(context).emailCon,
                          label: "E-mail",
                          hint: "Enter your E-mail",
                          iconData: Icons.email,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        from: 30,
                        delay: const Duration(milliseconds: 210),
                        child: ObscureTextFieldBuilder(
                          controller:
                              BlocProvider.of<SignUpCubit>(context).passwordCon,
                          obscureText:
                              BlocProvider.of<SignUpCubit>(context).obscureText,
                          icon: BlocProvider.of<SignUpCubit>(context).icon,
                          label: "Password",
                          hint: "Enter your password",
                          iconData: Icons.password,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        from: 30,
                        delay: const Duration(milliseconds: 280),
                        child: ObscureTextFieldBuilder(
                          controller: BlocProvider.of<SignUpCubit>(context)
                              .passwordConfirmCon,
                          obscureText: BlocProvider.of<SignUpCubit>(context)
                              .confirmObscureText,
                          icon: BlocProvider.of<SignUpCubit>(context).confIcon,
                          label: "Confirm password",
                          hint: "Confirm your password",
                          iconData: Icons.password,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        from: 30,
                        delay: const Duration(milliseconds: 350),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BlocBuilder<SignUpCubit, SignUpState>(
                            builder: (context, state) {
                              if (state is SignUpInitial) {
                                return MaterialButton(
                                  onPressed: () =>
                                      BlocProvider.of<SignUpCubit>(context)
                                          .signUp(context),
                                  minWidth: double.infinity,
                                  height: 50,
                                  color: Colors.white,
                                  elevation: 5,
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontFamily: 'f',
                                        fontSize: 20,
                                        color: ConstColors.main),
                                  ),
                                );
                              } else {
                                return LoadingAnimationWidget.threeArchedCircle(
                                    color: Colors.white, size: 50);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FadeInDown(
        from: 30,
        delay: const Duration(milliseconds: 400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FittedBox(
              child: Text(
                "Don't have an account ? ",
                style: TextStyle(
                    fontFamily: 'f', fontSize: 18, color: Colors.white),
              ),
            ),
            FittedBox(
              child: TextButton(
                onPressed: () =>
                    BlocProvider.of<SignUpCubit>(context).openLogin(context),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontFamily: 'f',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 160,
            ),
          ],
        ),
      ),
    );
  }
}
