import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/data/helpers/auth_helper.dart';
import 'package:testt/logic/home/home_cubit.dart';
import 'package:testt/presentation/widgets/drawer.dart';
import 'package:testt/presentation/widgets/exercises.dart';
import 'package:testt/presentation/widgets/placeholder/error.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:testt/presentation/widgets/placeholder/no_internet.dart';

import '../../../constants/strings.dart';
import '../../../data/helpers/random.dart';
import '../../widgets/macro.dart';
import '../../widgets/meal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getWeekDay(int day) {
    switch (day) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "Sun";
    }
  }

  String dateString(DateTime date) {
    DateTime now = DateTime.now();
    if (date.day == now.day &&
        date.year == now.year &&
        date.month == now.month) {
      return 'Today';
    } else if (date.day == now.day - 1 &&
        date.year == now.year &&
        date.month == now.month) {
      return 'Yesterday';
    } else if (date.day == now.day + 1 &&
        date.year == now.year &&
        date.month == now.month) {
      return 'Tomorrow';
    } else {
      return '${getWeekDay(date.weekday)} ${date.day} / ${date.month} / ${date.year}';
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
      ),
    );
    BlocProvider.of<HomeCubit>(context).getDay();
    super.initState();
  }

  final ValueNotifier<double> kcalValueNotifier = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: const HomeDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            final day = state.day;
            kcalValueNotifier.value = day.kcalConsumed.toDouble();
            return ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: ListView(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Material(
                      elevation: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              !day.isFree
                                  ? ConstColors.secDark
                                  : ConstColors.cheatDark,
                              !day.isFree
                                  ? ConstColors.secMid
                                  : ConstColors.cheatMid,
                              !day.isFree ? ConstColors.sec : ConstColors.cheat,
                              !day.isFree
                                  ? ConstColors.secMidOff
                                  : ConstColors.cheatMidOff,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: !day.isFree
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: IconButton(
                                                onPressed: () {
                                                  Scaffold.of(
                                                    context,
                                                  ).openDrawer();
                                                },
                                                icon: const Icon(
                                                  Icons.menu,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            day.kcalConsumed.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "F",
                                              fontSize: 22,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            "EATEN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "F",
                                              fontSize: 12,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const Spacer(flex: 2),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: FittedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SimpleCircularProgressBar(
                                                backStrokeWidth: 4,
                                                progressStrokeWidth: 4,
                                                progressColors: const [
                                                  Colors.white54,
                                                  Colors.white,
                                                ],
                                                maxValue: day.kcalGoal
                                                    .toDouble(),
                                                valueNotifier:
                                                    kcalValueNotifier,
                                                backColor: Colors.green[900]!,
                                                animationDuration: 0,
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                ((day.kcalGoal -
                                                            state
                                                                .day
                                                                .kcalConsumed)
                                                        .abs())
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "F",
                                                  fontSize: 30,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                day.kcalGoal -
                                                            state
                                                                .day
                                                                .kcalConsumed <
                                                        0
                                                    ? "KCAL OVER"
                                                    : "KCAL LEFT",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "F",
                                                  fontSize: 20,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: IconButton(
                                                onPressed: () {
                                                  AuthenticationHelper.instance
                                                      .logout();
                                                  Navigator.pushReplacementNamed(context, Routes.welcomeRoute);
                                                },
                                                icon: const Icon(
                                                  Icons.bolt_rounded,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            day.kcalBurned.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "F",
                                              fontSize: 22,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            "BURNED",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "F",
                                              fontSize: 12,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const Spacer(flex: 2),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Cheat Day",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "F",
                                          fontSize: 45,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "(you can eat whatever you want)",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "F",
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            BlocProvider.of<HomeCubit>(
                              context,
                            ).decrementDay(day: day);
                          },
                          splashRadius: 25,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: BlocProvider.of<HomeCubit>(
                                context,
                              ).date,
                              firstDate: DateTime.now().subtract(
                                Duration(days: 300),
                              ),
                              lastDate: DateTime.now().add(
                                Duration(days: 300),
                              ),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.green,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((value) {
                              BlocProvider.of<HomeCubit>(
                                context,
                              ).changeDay(newDate: value!, day: day);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              dateString(day.date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "F",
                                fontSize: 20,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            BlocProvider.of<HomeCubit>(
                              context,
                            ).incrementDay(day: day);
                          },
                          splashRadius: 25,
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    animate: state.animate,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.035,
                            0,
                            20,
                            MediaQuery.of(context).size.width * 0.035,
                          ),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Macro(
                                    target: day.proteinGoal,
                                    eaten: day.proteinCons,
                                    macro: 'Protein',
                                    color: Colors.red[400]!,
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  Macro(
                                    target: day.carbGoal,
                                    eaten: day.carbCons,
                                    macro: 'Carb',
                                    color: Colors.orange[400]!,
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  Macro(
                                    target: day.fatGoal,
                                    eaten: day.fatCons,
                                    macro: 'Fat',
                                    color: Colors.yellow[400]!,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.035),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<HomeCubit>(context).switchCheatDay(
                                  !day.isFree,
                                  day: day,
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      day.isFree ? "Go back on " : "Want to take a ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: "F",
                                        fontSize: 17,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      day.isFree ? "diet" : "cheat day",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "F",
                                        color: day.isFree
                                            ? Colors.green
                                            : ConstColors.cheatMidOff,
                                      ),
                                    ),
                                    const Text(
                                      " ?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "F",
                                        fontSize: 17,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        MealWrapper(
                          key: ValueKey(
                            '${day.date}_Breakfast_${idGenerator()}',
                          ),
                          icon: Icons.coffee,
                          meal: "Breakfast",
                          consumables: day.breakfast,
                          isFree: day.isFree,
                          date: day.date,
                        ),
                        MealWrapper(
                          key: ValueKey('${day.date}_Lunch_${idGenerator()}'),
                          icon: Icons.lunch_dining,
                          meal: "Lunch",
                          consumables: day.lunch,
                          isFree: day.isFree,
                          date: day.date,
                        ),
                        MealWrapper(
                          key: ValueKey('${day.date}_Dinner_${idGenerator()}'),
                          icon: Icons.dinner_dining,
                          meal: "Dinner",
                          consumables: day.dinner,
                          isFree: day.isFree,
                          date: day.date,
                        ),
                        MealWrapper(
                          key: ValueKey('${day.date}_Snacks_${idGenerator()}'),
                          icon: Icons.local_pizza,
                          meal: "Snacks",
                          consumables: day.snacks,
                          isFree: day.isFree,
                          date: day.date,
                        ),
                        Exercises(exercises: day.exercises, isFree: day.isFree),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is HomeNoInternet) {
            return NoInternet();
          } else if (state is HomeError) {
            return ErrorScreen(errorMessage: state.errorMessage);
          } else {
            return LoadingWidget();
          }
        },
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
