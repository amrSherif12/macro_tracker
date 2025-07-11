import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/logic/food/food_cubit.dart';
import 'package:testt/logic/food/recipes_cubit.dart';
import 'package:testt/presentation/screens/authentication/login.dart';
import 'package:testt/presentation/screens/authentication/sign_up.dart';
import 'package:testt/presentation/screens/authentication/welcome.dart';
import 'package:testt/presentation/screens/food/create_food.dart';
import 'package:testt/presentation/screens/food/create_recipe.dart';
import 'package:testt/presentation/screens/food/food_info.dart';
import 'package:testt/presentation/screens/food/recipe_info.dart';
import 'package:testt/presentation/screens/home/add_food.dart';
import 'package:testt/presentation/screens/home/meal_info.dart';
import 'package:testt/presentation/screens/loading.dart';
import 'package:testt/presentation/screens/navigation.dart';
import 'package:testt/presentation/screens/undefined_screen.dart';

import 'constants/strings.dart';
import 'logic/authentication/login_cubit.dart';
import 'logic/authentication/sign_up_cubit.dart';
import 'logic/navigation_cubit.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.loginRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => LoginCubit(),
          child: const Login(),
        ),
      );

    case Routes.signUpRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => SignUpCubit(),
          child: const SignUp(),
        ),
      );

    case Routes.navigationRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => NavigationCubit(),
          child: const Navigation(),
        ),
      );
    case Routes.createFoodRoute:
      final args = settings.arguments as CreateFood;
      final foodTabCubit = BlocProvider.of<FoodCubit>(args.foodTabContext);
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: foodTabCubit,
          child: CreateFood(foodTabContext: args.foodTabContext),
        ),
      );

    case Routes.recipeInfoRoute:
      final args = settings.arguments as RecipeInfo;
      final recipeTabCubit = args.refreshContext != null
          ? BlocProvider.of<RecipesCubit>(args.refreshContext!)
          : null;
      return MaterialPageRoute(
        builder: (context) => recipeTabCubit != null
            ? BlocProvider.value(
                value: recipeTabCubit,
                child: RecipeInfo(
                  recipe: args.recipe,
                  refreshContext: args.refreshContext,
                ),
              )
            : RecipeInfo(recipe: args.recipe),
      );

    case Routes.createRecipeRoute:
      final args = settings.arguments as CreateRecipe;
      final recipeTabCubit = BlocProvider.of<RecipesCubit>(args.refreshContext);
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: recipeTabCubit,
          child: CreateRecipe(
            ingredients: args.ingredients,
            refreshContext: args.refreshContext,
          ),
        ),
      );

    case Routes.foodInfoRoute:
      final args = settings.arguments as FoodInfo;
      return MaterialPageRoute(
        builder: (context) =>
            FoodInfo(food: args.food, refreshContext: args.refreshContext),
      );

    case Routes.mealInfoRoute:
      final args = settings.arguments as MealInfo;
      return MaterialPageRoute(
        builder: (context) =>
            MealInfo(food: args.food, meal: args.meal, date: args.date, dairyContext: args.dairyContext,),
      );

    case Routes.addFoodRoute:
      final args = settings.arguments as AddFood;
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FoodCubit()),
            BlocProvider(create: (context) => RecipesCubit()),
          ],
          child: AddFood(
            date: args.date,
            meal: args.meal,
            dairyContext: args.dairyContext,
          ),
        ),
      );

    case Routes.loadingRoute:
      return MaterialPageRoute(builder: (context) => const Loading());

    case Routes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => const Welcome());

    default:
      return MaterialPageRoute(builder: (context) => const Undefined());
  }
}
