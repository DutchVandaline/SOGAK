import 'package:sogak/Theme/MainTheme.dart';
import 'package:flutter/material.dart';
import 'package:sogak/Screens/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MainTheme().theme,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: [
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          //LoginScreen(),
          //SearchScreen(),
          //LibraryScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_filled), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.search), label: "Search"),
            NavigationDestination(
                icon: Icon(Icons.library_books_outlined),
                label: "My Library"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        ),
      ),
    );
  }
}
