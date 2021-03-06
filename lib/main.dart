import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kungchidda_dictionary/screen/favorite_screen.dart';
import 'package:kungchidda_dictionary/screen/history_screen.dart';
import 'package:kungchidda_dictionary/screen/search_screen.dart';
// import 'package:kungchidda_dictionary/screen/login_screen.dart';
import 'package:kungchidda_dictionary/screen/setting_screen.dart';
import 'package:kungchidda_dictionary/screen/user_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/userInfoScreen': (BuildContext context) => const UserInfoScreen(),
      },
      home: const Homepage(),
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
  static const platform = MethodChannel('example.com/value');
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
    // return  SearchScreen();
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
      // _pageController.animateToPage(index, duration:  Duration(milliseconds: 500), curve: Curves.ease);
      // _pageController.animateTo(1.0, duration:  Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }
}
