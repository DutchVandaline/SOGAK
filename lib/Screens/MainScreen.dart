import 'package:sogak/Theme/MainTheme.dart';
import 'package:flutter/material.dart';
import 'package:sogak/Screens/HomeScreen.dart';
import 'package:sogak/Screens/ListScreen.dart';
import 'package:sogak/Screens/SogakScreen.dart';

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
          SogakScreen(),
          ListScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_filled), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.local_fire_department_outlined, size: 30.0,),
                label: "Sogak"),
            NavigationDestination(
                icon: Icon(Icons.list_outlined), label: "List"),
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
