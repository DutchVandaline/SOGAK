import 'package:sogak/Theme/MainTheme.dart';
import 'package:flutter/material.dart';
import 'package:sogak/Screens/HomeScreen.dart';
import 'package:sogak/Screens/ListScreen.dart';
import 'package:sogak/Screens/SogakScreen.dart';
import 'package:sogak/Screens/CalendarScreen.dart';
import 'package:sogak/Screens/ProfileScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MainTheme().theme,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: [
          HomeScreen(),
          CalendarScreen(),
          SogakScreen(),
          ListScreen(),
          ProfileScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_filled), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined), label: "Monthly"),
            NavigationDestination(
                icon: Icon(Icons.local_fire_department_outlined), label: "Sogak"),
            NavigationDestination(
                icon: Icon(Icons.list_outlined), label: "List"),
            NavigationDestination(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.5,
        ),
      ),
    );
  }
}
