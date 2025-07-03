class Routes {
  static const String loadingRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String navigationRoute = '/navigation';
  static const String createFoodRoute = '/createFood';
  static const String createRecipeRoute = '/createRecipe';
  static const String foodInfoRoute = '/foodInfo';
  static const String addFoodRoute = '/addFood';
  static const String mealInfoRoute = '/meanInfo';
  static const String recipeInfoRoute = '/recipeInfo';
  static const String welcomeRoute = '/welcome';
  static const String undefinedRoute = '/undefined';
  static const String signUpRoute = '/signUp';
  static const String unsupportedPlatformRoute = '/unsupportedPlatform';
}

class Lists {
  static const List<String> units = <String>[
    'per 100 gm',
    'per 100 ml',
    'per piece',
    'per table spoon',
  ];
}

enum Tile { removeFood, addDairy, removeDairy, search }
