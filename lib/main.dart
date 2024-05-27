import 'package:flutter/material.dart';
import '../screen/LeagueScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Color.fromRGBO(49, 170, 211, 1),
    brightness: Brightness.dark,
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rasponsi Praktikum Teknologi Mobile',
      theme: theme,
      home: LeaguePage(),
    );
  }
}
