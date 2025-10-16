import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationHome());

  void openUndefinedPage() {
    emit(NavigationUndefinedPage());
  }

  void openHome() {
    emit(NavigationHome());
  }

  void openSearch() {
    emit(NavigationSearch());
  }

  void openFood() {
    emit(NavigationFood());
  }

  void openProfile() {
    emit(NavigationProfile());
  }
}
