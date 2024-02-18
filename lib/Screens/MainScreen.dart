import 'package:sogak/Theme/MainTheme.dart';
import 'package:flutter/material.dart';
import 'package:sogak/Screens/HomeScreen.dart';
import 'package:sogak/Screens/ListScreen.dart';
import 'package:sogak/Screens/SogakScreen.dart';
import 'package:sogak/Screens/CalendarScreen.dart';
import 'package:sogak/Screens/SettingScreen.dart';

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
      debugShowCheckedModeBanner: false,
      theme: MainTheme().theme,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: [
          const HomeScreen(),
          const CalendarScreen(),
          const SogakScreen(),
          const ListScreen(),
          const SettingScreen(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_filled), label: "홈"),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined), label: "캘린더"),
            NavigationDestination(
                icon: Icon(Icons.local_fire_department_outlined), label: "소각로"),
            NavigationDestination(
                icon: Icon(Icons.list_outlined), label: "목록"),
            NavigationDestination(
                icon: Icon(Icons.settings), label: "설정"),
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
