class FilterModel {
  bool isRecipe;
  bool filtersOn;
  int kcalStart;
  int kcalEnd;
  int proteinStart;
  int proteinEnd;
  int carbStart;
  int carbEnd;
  int fatStart;
  int fatEnd;

  FilterModel({
    required this.isRecipe,
    required this.filtersOn,
    required this.kcalStart,
    required this.kcalEnd,
    required this.proteinStart,
    required this.proteinEnd,
    required this.carbStart,
    required this.carbEnd,
    required this.fatStart,
    required this.fatEnd,
  });

  FilterModel.init({
    this.isRecipe = false,
    this.filtersOn = false,
    this.kcalStart = 0,
    this.kcalEnd = 1500,
    this.proteinEnd = 100,
    this.proteinStart = 0,
    this.carbEnd = 100,
    this.carbStart = 0,
    this.fatEnd = 100,
    this.fatStart = 0,
  });
}
