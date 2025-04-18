import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/presentation/screens/undefined_screen.dart';
import 'router.dart' as router;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();

  FirebaseAuth.instance.authStateChanges().listen(
    (User? user) async {
      if (user == null) {
        await prefs.setString("loggedIn", "no");
      } else {
        await prefs.setString("loggedIn", "yes");
      }
    },
  );

  runApp(
    const RootRestorationScope(
      restorationId: 'root',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MaterialApp(
        theme: ThemeData(
            splashColor: ConstColors.sec.withOpacity(0.6), fontFamily: 'F'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
        initialRoute: Routes.loadingRoute,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const Undefined()),
      ),
    );
  }
}
