part of 'theme_bloc.dart';

class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);

  static ThemeState get lightTheme => ThemeState(AppTheme.light);

  static ThemeState get darkTheme => ThemeState(AppTheme.dark);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
      );
}
