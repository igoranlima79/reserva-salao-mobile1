import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(ClassePrincipal());

class ClassePrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          )),
      home: HomePage(),
    );
  }
}
