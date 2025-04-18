import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macro_tracker_2/constants/colors.dart';
import 'package:macro_tracker_2/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/logic/food/food_cubit.dart';
import 'package:macro_tracker_2/logic/food/recipes_cubit.dart';
import 'package:macro_tracker_2/presentation/screens/food/food_tab.dart';
import 'package:macro_tracker_2/presentation/screens/food/recipe_tab.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: ConstColors.main,
        statusBarColor: ConstColors.sec));
    tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<FoodCubit>(context).getFood();
    BlocProvider.of<RecipesCubit>(context).getRecipes();
    super.initState();
  }

  void refreshFoodTab() {
    BlocProvider.of<FoodCubit>(context).getFood(isRefresh: true);
  }

  void refreshRecipeTab() {
    BlocProvider.of<RecipesCubit>(context).getRecipes(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        backgroundColor: ConstColors.sec,
        toolbarHeight: 10,
        bottom: TabBar(
          controller: tabController,
          unselectedLabelStyle:
              TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 19),
          labelStyle: const TextStyle(
              color: Colors.white, fontSize: 22, fontFamily: 'f'),
          dividerColor: ConstColors.secMid,
          indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          tabs: const [
            Tab(
              child: Text(
                'My Foods',
                style: TextStyle(fontFamily: 'f'),
              ),
            ),
            Tab(
              child: Text(
                'My Recipes',
                style: TextStyle(fontFamily: 'f'),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: tabController, children: [
        FoodTab(refresh: refreshFoodTab),
        RecipeTab(refresh: refreshRecipeTab)
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabController.index == 0) {
            await Navigator.pushNamed(context, Routes.createFoodRoute);
            refreshFoodTab();
          } else {
            await Navigator.pushNamed(context, Routes.createRecipeRoute);
            refreshRecipeTab();
          }
        },
        backgroundColor: ConstColors.sec,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
