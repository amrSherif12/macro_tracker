import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testt/data/helpers/firestore/day_repository.dart';
import 'dart:io' show Platform;

import '../../constants/colors.dart';
import '../../constants/strings.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void navigation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loggedIn = prefs.getString("loggedIn");
    await DayRepository.instance.addUserDocument();

    if (!Platform.isAndroid) {
      Navigator.pushReplacementNamed(context, Routes.unsupportedPlatformRoute);
    } else if (loggedIn == "no" || loggedIn == null) {
      Navigator.pushReplacementNamed(context, Routes.welcomeRoute);
    } else {
      Navigator.pushReplacementNamed(context, Routes.navigationRoute);
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.sec,
        statusBarColor: ConstColors.secDark,
      ),
    );
    navigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ConstColors.secDark, ConstColors.sec],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
