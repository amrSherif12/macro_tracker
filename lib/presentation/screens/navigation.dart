import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/logic/search/search_cubit.dart';
import 'package:testt/presentation/screens/exercise/exercise.dart';
import 'package:testt/presentation/screens/food/food.dart';
import 'package:testt/presentation/screens/search/search.dart';
import 'package:testt/presentation/screens/undefined_screen.dart';

import '../../constants/colors.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/navigation_cubit.dart';
import 'home/home.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          if (state is NavigationHome) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<HomeCubit>()),
                BlocProvider.value(value: context.read<FoodCubit>()),
                BlocProvider.value(value: context.read<RecipesCubit>()),
              ],
              child: const Home(),
            );
          } else if (state is NavigationSearch) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<SearchCubit>()),
                BlocProvider.value(value: context.read<FoodCubit>()),
                BlocProvider.value(value: context.read<RecipesCubit>()),
              ],
              child: const Search(),
            );
          } else if (state is NavigationExercise) {
            return BlocProvider(
              create: (BuildContext context) => SearchCubit(),
              child: const Exercise(),
            );
          } else if (state is NavigationFood) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => FoodCubit()),
                BlocProvider(create: (context) => RecipesCubit()),
              ],
              child: const Food(tile: Tile.removeFood),
            );
          } else {
            return const Undefined();
          }
        },
      ),
      bottomNavigationBar: Container(
        color: ConstColors.main,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GNav(
            onTabChange: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(context).openHome();
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context).openSearch();
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(context).openExercise();
              } else if (index == 3) {
                BlocProvider.of<NavigationCubit>(context).openFood();
              }
            },
            backgroundColor: ConstColors.main,
            duration: const Duration(milliseconds: 500),
            gap: 10,
            tabActiveBorder: Border.all(color: Colors.white, width: 1),
            padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
            tabs: const [
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.white,
                textColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: "f",
                  color: Colors.white,
                  fontSize: 14,
                ),
                icon: Icons.book,
                text: 'Diary',
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.white,
                textColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: "f",
                  color: Colors.white,
                  fontSize: 14,
                ),
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.white,
                textColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: "f",
                  color: Colors.white,
                  fontSize: 14,
                ),
                icon: Icons.fitness_center,
                text: 'Exercises',
              ),
              GButton(
                iconActiveColor: Colors.white,
                iconColor: Colors.white,
                textColor: Colors.white,
                textStyle: TextStyle(
                  fontFamily: "f",
                  color: Colors.white,
                  fontSize: 14,
                ),
                icon: Icons.restaurant,
                text: 'Food',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
