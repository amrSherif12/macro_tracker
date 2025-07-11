import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testt/constants/colors.dart';
import 'package:testt/constants/strings.dart';
import 'package:testt/data/helpers/debouncer.dart';
import 'package:testt/data/models/filter_model.dart';
import 'package:testt/data/models/food_model.dart';
import 'package:testt/data/models/recipe_model.dart';
import 'package:testt/logic/search/search_cubit.dart';
import 'package:testt/presentation/widgets/filters.dart';
import 'package:testt/presentation/widgets/food_tile.dart';
import 'package:testt/presentation/widgets/placeholder/error.dart';
import 'package:testt/presentation/widgets/placeholder/loading_widget.dart';
import 'package:testt/presentation/widgets/placeholder/no_internet.dart';
import 'package:testt/presentation/widgets/recipe_tile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isRecipe = false;
  TextEditingController controller = TextEditingController();
  FilterModel filters = FilterModel.init();
  DeBouncer deBouncer = DeBouncer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ConstColors.main,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        backgroundColor: ConstColors.main,
        title: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller,
                onChanged: (query) async {
                  deBouncer.call(() {
                    BlocProvider.of<SearchCubit>(
                      context,
                    ).search(query, filters);
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[850],
                  filled: true,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      bool? applyFilters = await showDialog(
                        context: context,
                        builder: (context) => Filters(filters: filters),
                      );
                      if (applyFilters == true) {
                        BlocProvider.of<SearchCubit>(
                          context,
                        ).search(controller.text, filters);
                      }
                    },
                    icon: Icon(Icons.tune, color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'f'),
                ),
                style: const TextStyle(fontFamily: 'f', color: Colors.white),
                cursorColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (state.consumables.first is FoodModel) {
                  return FoodTile(
                    food: (state.consumables[index] as FoodModel),
                    saved: state.saved,
                    tile: Tile.search,
                  );
                } else {
                  return RecipeTile(
                    recipe: (state.consumables[index] as RecipeModel),
                    saved: state.saved,
                    tile: Tile.search,
                  );
                }
              },
              itemCount: state.consumables.length,
            );
          } else if (state is SearchBarEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    child: Image.asset('assets/imgs/search.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hungry?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Find your favorite meal',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (state is SearchNoMatch) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    child: Image.asset('assets/imgs/error.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Rsesults',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Couldn’t find any matches.',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (state is NoInternet) {
            return NoInternet();
          } else if (state is SearchError) {
            return ErrorScreen(errorMessage: state.errorMessage);
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
