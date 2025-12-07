import 'package:flutter/material.dart';
import 'models/unit_model.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/default_units.dart';

void main() {
  runApp(const DonermatikApp());
}

class DonermatikApp extends StatelessWidget {
  const DonermatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dönermatik",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Şimdilik buradan yönetiyoruz
  late List<UnitModel> _units;

  @override
  void initState() {
    super.initState();
    _units = List<UnitModel>.from(DefaultUnits.units);
  }

  void _updateUnits(List<UnitModel> newUnits) {
    setState(() {
      _units = newUnits;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(units: _units),
      SettingsScreen(units: _units, onUnitsChanged: _updateUnits),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Hesapla",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
