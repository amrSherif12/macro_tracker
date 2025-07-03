import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testt/constants/colors.dart';

import '../../../constants/strings.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF171717),
        statusBarColor: Color(0xFF171717),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: SizedBox(
              width: 300,
              child: Image.asset('assets/imgs/veg.jpg'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 2.5),
              FadeInDown(
                from: 30,
                child: Text(
                  "Hi there !",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'f',
                    fontSize: 23,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInDown(
                from: 30,
                delay: const Duration(milliseconds: 70),
                child: const Text(
                  "Welcome To App",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'f',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(flex: 5,),
              FadeInDown(
                from: 30,
                delay: const Duration(milliseconds: 140),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.loginRoute,
                        );
                      },
                      minWidth: double.infinity,
                      height: 40,
                      color: ConstColors.sec,
                      elevation: 5,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontFamily: 'f',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF213F1B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FadeInDown(
                from: 30,
                delay: const Duration(milliseconds: 210),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.signUpRoute,
                        );
                      },
                      minWidth: double.infinity,
                      height: 40,
                      color: ConstColors.sec,
                      elevation: 5,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontFamily: 'f',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF213F1B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.lineTo(0, h - 40);
    path.quadraticBezierTo(w / 4, h, w / 2, h);
    path.quadraticBezierTo(w - w / 4, h, w, h - 40);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
