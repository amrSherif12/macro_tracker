import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_tracker_2/logic/food/food_cubit.dart';
import 'package:macro_tracker_2/logic/food/food_info_cubit.dart';
import 'package:macro_tracker_2/logic/food/recipe_info_cubit.dart';
import 'package:macro_tracker_2/presentation/screens/authentication/login.dart';
import 'package:macro_tracker_2/presentation/screens/authentication/sign_up.dart';
import 'package:macro_tracker_2/presentation/screens/authentication/welcome.dart';
import 'package:macro_tracker_2/presentation/screens/food/create_food.dart';
import 'package:macro_tracker_2/presentation/screens/food/create_recipe.dart';
import 'package:macro_tracker_2/presentation/screens/food/food_info.dart';
import 'package:macro_tracker_2/presentation/screens/food/recipe_info.dart';
import 'package:macro_tracker_2/presentation/screens/home/add_food.dart';
import 'package:macro_tracker_2/presentation/screens/loading.dart';
import 'package:macro_tracker_2/presentation/screens/navigation.dart';
import 'package:macro_tracker_2/presentation/screens/undefined_screen.dart';
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
              child: const Login()));

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
              child: const Navigation()));

    case Routes.createFoodRoute:
      return MaterialPageRoute(builder: (context) => const CreateFood());

    case Routes.recipeInfoRoute:
      final args = settings.arguments as RecipeInfo;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => RecipeInfoCubit(),
                child: RecipeInfo(id: args.id),
              ));

    case Routes.createRecipeRoute:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => FoodCubit(),
          child: const CreateRecipe(),
        ),
      );

    case Routes.foodInfoRoute:
      final args = settings.arguments as FoodInfo;
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => FoodInfoCubit(),
                child: FoodInfo(id: args.id),
              ));

    case Routes.addFoodRoute:
      return MaterialPageRoute(builder: (context) => const AddFood());

    case Routes.loadingRoute:
      return MaterialPageRoute(builder: (context) => const Loading());

    case Routes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => const Welcome());

    default:
      return MaterialPageRoute(builder: (context) => const Undefined());
  }
}
