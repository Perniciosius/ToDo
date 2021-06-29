import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do/pages/home_page.dart';
import 'package:to_do/provider/theme_provider.dart';
import 'package:to_do/provider/todo_provider.dart';
import 'package:to_do/utils/constants.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
          lazy: false,
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'To Do',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: lightBackgroundColor,
              elevation: 0.0,
            ),
            fontFamily: GoogleFonts.varelaRound().fontFamily,
            primaryColor: lightBackgroundColor,
            buttonColor: lightButtonColor,
            iconTheme: IconThemeData(color: lightTextColor),
            scaffoldBackgroundColor: lightBackgroundColor,
            cardColor: lightListItemColor,
            accentColor: lightButtonColor,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: lightTextColor,
                fontWeight: fontWeight,
              ),
              headline1: TextStyle(
                color: lightTextColor,
                fontWeight: fontWeight,
              ),
              headline4: TextStyle(
                color: lightTextColor,
                fontWeight: fontWeight,
              ),
              subtitle1: TextStyle(
                color: lightTextColor,
                fontWeight: fontWeight,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: lightButtonColor,
              foregroundColor: darkTextColor,
              focusColor: lightButtonColor,
            ),
          ),
          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: darkBackgroundColor,
              elevation: 0.0,
            ),
            fontFamily: GoogleFonts.varelaRound().fontFamily,
            primaryColor: darkBackgroundColor,
            scaffoldBackgroundColor: darkBackgroundColor,
            buttonColor: darkButtonColor,
            iconTheme: IconThemeData(color: darkTextColor),
            cardColor: darkListItemColor,
            accentColor: darkButtonColor,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: darkTextColor,
                fontWeight: fontWeight,
              ),
              headline1: TextStyle(
                color: darkTextColor,
                fontWeight: fontWeight,
              ),
              headline4: TextStyle(
                color: darkTextColor,
                fontWeight: fontWeight,
              ),
              subtitle1: TextStyle(
                color: darkTextColor,
                fontWeight: fontWeight,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkButtonColor,
              foregroundColor: darkTextColor,
              focusColor: darkButtonColor,
            ),
          ),
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
