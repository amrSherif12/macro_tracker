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
      return MaterialPageRoute(builder: (context) => CreateFood());

    case Routes.recipeInfoRoute:
      final args = settings.arguments as RecipeInfo;
      return MaterialPageRoute(
        builder: (context) => RecipeInfo(recipe: args.recipe),
      );

    case Routes.createRecipeRoute:
      final args = settings.arguments as CreateRecipe;
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => FoodCubit(),
          child: CreateRecipe(ingredients: args.ingredients,),
        ),
      );

    case Routes.foodInfoRoute:
      final args = settings.arguments as FoodInfo;
      return MaterialPageRoute(builder: (context) => FoodInfo(food: args.food));

    case Routes.mealInfoRoute:
      final args = settings.arguments as MealInfo;
      return MaterialPageRoute(
        builder: (context) =>
            MealInfo(food: args.food, meal: args.meal, date: args.date),
      );

    case Routes.addFoodRoute:
      final args = settings.arguments as AddFood;
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FoodCubit()),
            BlocProvider(create: (context) => RecipesCubit()),
          ],
          child: AddFood(date: args.date, meal: args.meal),
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
