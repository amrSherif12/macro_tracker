import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../data/helpers/auth_helper.dart';
import '../../../logic/authentication/login_cubit.dart';
import '../../widgets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
        statusBarColor: ConstColors.main,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstColors.main,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ConstColors.main, ConstColors.main],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              FadeInDown(
                from: 30,
                child: const FittedBox(
                  child: Text(
                    "Welcome Back !",
                    style: TextStyle(
                      fontFamily: 'f',
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(),
              Column(
                children: [
                  FadeInDown(
                    from: 30,
                    delay: const Duration(milliseconds: 100),
                    child: FilledTextFieldBuilder(
                      hint: "Enter your E-mail",
                      label: "E-mail",
                      controller: BlocProvider.of<LoginCubit>(context).emailCon,
                      iconData: Icons.email,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInDown(
                    from: 30,
                    delay: const Duration(milliseconds: 200),
                    child: ObscureTextFieldBuilder(
                      controller: BlocProvider.of<LoginCubit>(
                        context,
                      ).passwordCon,
                      obscureText: BlocProvider.of<LoginCubit>(
                        context,
                      ).obscureText,
                      icon: BlocProvider.of<LoginCubit>(context).icon,
                      label: "Password",
                      hint: "Enter your password",
                      iconData: Icons.password,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 300),
                    from: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          if (state is LoginInitial) {
                            return MaterialButton(
                              onPressed: () {
                                BlocProvider.of<LoginCubit>(
                                  context,
                                ).login(context);
                              },
                              minWidth: double.infinity,
                              height: 50,
                              color: Colors.white,
                              elevation: 5,
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'LOG IN',
                                style: TextStyle(
                                  fontFamily: 'f',
                                  fontSize: 20,
                                  color: ConstColors.main,
                                ),
                              ),
                            );
                          } else {
                            return LoadingAnimationWidget.threeArchedCircle(
                              color: Colors.white,
                              size: 50,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                  fontFamily: 'f',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            FittedBox(
              child: TextButton(
                onPressed: () =>
                    BlocProvider.of<LoginCubit>(context).openSignUp(context),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontFamily: 'f',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }
}
