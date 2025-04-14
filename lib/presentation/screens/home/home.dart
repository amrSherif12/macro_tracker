import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/data/helpers/auth_helper.dart';
import 'package:macro_tracker_2/logic/home/home_cubit.dart';
import 'package:macro_tracker_2/presentation/widgets/drawer.dart';
import 'package:macro_tracker_2/presentation/widgets/exercises.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/error.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/loading_widget.dart';
import 'package:macro_tracker_2/presentation/widgets/placeholder/no_internet.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../utils.dart';
import '../../widgets/macro.dart';
import '../../widgets/meal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
        statusBarColor: ConstColors.secDark));
    BlocProvider.of<HomeCubit>(context).getDay(day: null);
    super.initState();
  }

  ValueNotifier kcalValueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: const HomeDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            final day = state.day;
            kcalValueNotifier.value =
                ValueNotifier(day.kcalConsumed.toDouble());
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
                                                  Scaffold.of(context)
                                                      .openDrawer();
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
                                                fontWeight: FontWeight.bold),
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
                                          const Spacer(
                                            flex: 2,
                                          ),
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
                                                  Colors.white
                                                ],
                                                maxValue:
                                                    day.kcalGoal.toDouble(),
                                                valueNotifier:
                                                    kcalValueNotifier.value,
                                                backColor: Colors.green[900]!,
                                                animationDuration: 1,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                (day.kcalGoal -
                                                        state.day.kcalConsumed)
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "F",
                                                    fontSize: 30,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text(
                                                "KCAL LEFT",
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
                                                      .logout(context);
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
                                                fontWeight: FontWeight.bold),
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
                                          const Spacer(
                                            flex: 2,
                                          ),
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
                                            fontWeight: FontWeight.bold),
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
                                            fontWeight: FontWeight.bold),
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
                            BlocProvider.of<HomeCubit>(context)
                                .decrementDay(day: day);
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
                                initialDate:
                                    BlocProvider.of<HomeCubit>(context).date,
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 300)),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.green,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                }).then(
                              (value) {
                                BlocProvider.of<HomeCubit>(context)
                                    .changeDay(newDate: value!, day: day);
                              },
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                '${day.date.day} / ${day.date.month} / ${day.date.year}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "F",
                                  fontSize: 20,
                                  letterSpacing: 1,
                                ),
                              )),
                        ),
                        IconButton(
                          onPressed: () async {
                            BlocProvider.of<HomeCubit>(context)
                                .incrementDay(day: day);
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
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                    animate: state.animate,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              0,
                              20,
                              MediaQuery.of(context).size.width * 0.05),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[850],
                              ),
                              child: Column(
                                children: [
                                  Macro(
                                    target: day.proteinGoal,
                                    eaten: day.proteinCons,
                                    macro: 'Protein',
                                    color: Colors.red,
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: Colors.grey[900],
                                  ),
                                  Macro(
                                    target: day.carbGoal,
                                    eaten: day.carbCons,
                                    macro: 'Carb',
                                    color: Colors.orange,
                                  ),
                                  Divider(
                                    height: 10,
                                    thickness: 2,
                                    color: Colors.grey[900],
                                  ),
                                  Macro(
                                    target: day.fatGoal,
                                    eaten: day.fatCons,
                                    macro: 'Fat',
                                    color: Colors.yellow,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[850],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: !day.isFree
                                  ? InkWell(
                                      onTap: () {
                                        BlocProvider.of<HomeCubit>(context)
                                            .switchCheatDay(true, day: day);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Want to take a ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "F",
                                                fontSize: 17,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            Text(
                                              'cheat day',
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.deepPurpleAccent,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "F",
                                              ),
                                            ),
                                            Text(
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
                                    )
                                  : InkWell(
                                      onTap: () {
                                        BlocProvider.of<HomeCubit>(context)
                                            .switchCheatDay(false, day: day);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Go back on ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "F",
                                                fontSize: 17,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            Text(
                                              'diet',
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "F",
                                              ),
                                            ),
                                            Text(
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
                        ),
                        Meal(
                          icon: Icons.coffee,
                          meal: "Breakfast",
                          food: day.breakfastFood,
                          recipes: day.breakfastRecipes,
                          isFree: day.isFree,
                        ),
                        Meal(
                          icon: Icons.lunch_dining,
                          meal: "Lunch",
                          food: day.lunchFood,
                          recipes: day.lunchRecipes,
                          isFree: day.isFree,
                        ),
                        Meal(
                          icon: Icons.dinner_dining,
                          meal: "Diner",
                          food: day.dinnerFood,
                          isFree: day.isFree,
                          recipes: day.dinnerRecipes,
                        ),
                        Meal(
                          icon: Icons.local_pizza,
                          meal: "Snacks",
                          food: day.snacksFood,
                          isFree: day.isFree,
                          recipes: day.snacksRecipes,
                        ),
                        Exercises(
                          exercises: day.exercises,
                          isFree: day.isFree,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is HomeNoInternet) {
            return NoInternet();
          } else if (state is HomeError) {
            return ErrorScreen(
              errorMessage: state.errorMessage,
            );
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
