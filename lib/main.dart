import 'package:flutter/material.dart';
import 'package:kungchidda_dictionary/screen/favoriteScreen.dart';
import 'package:kungchidda_dictionary/screen/historyScreen.dart';
import 'package:kungchidda_dictionary/screen/searchScreen.dart';
import 'package:kungchidda_dictionary/screen/settingScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController(initialPage: 0);
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: Icon(Icons.search),
          label: "Search"),
      const BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: Icon(Icons.history_edu),
        label: "History",
      ),
      const BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: Icon(Icons.favorite),
          label: "Favorite"),
      const BottomNavigationBarItem(
          backgroundColor: Colors.black,
          icon: Icon(Icons.settings),
          label: "Settings")
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return const SearchScreen();
    return Scaffold(
      body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: const [
            SearchScreen(),
            HistoryScreen(),
            FavoriteScreen(),
            SettingScreen()
          ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          bottomTapped(index);
        },
        currentIndex: bottomSelectedIndex,
        items: buildBottomNavBarItems(),
      ),
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      _pageController.jumpToPage(index);
      // _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      // _pageController.animateTo(1.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }
}
