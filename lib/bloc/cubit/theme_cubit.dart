

import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(LightThemeState()); 

 
  void switchToLight() => emit(LightThemeState());

  
  void switchToDark() => emit(DarkThemeState());
}
