import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/unit_model.dart';
import 'utils/default_units.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';

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
      home: const LoadingScreen(),
      routes: {"/main": (_) => const MainNavigation()},
    );
  }
}

//
// 1) LOADING SCREEN → onboarding tamam mı değil mi kontrol ediyor
//

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool? onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = prefs.getBool("onboarding_completed") ?? false;

    setState(() {
      onboardingCompleted = done;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onboardingCompleted == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return onboardingCompleted == false
        ? const OnboardingWrapper()
        : const MainNavigation();
  }
}

//
// 2) ONBOARDING WRAPPER → onboarding ekranını çalıştırır
//

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  List<UnitModel> units = List<UnitModel>.from(DefaultUnits.units);

  void _applyUnitSelection(List<UnitModel> selected) {
    setState(() {
      units = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(units: units, onUnitsSelected: _applyUnitSelection);
  }
}

//
// 3) ANA NAVIGATION
//

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  List<UnitModel> _units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? activeIds = prefs.getStringList("active_units");

    // Eğer onboarding hiç çalışmamışsa → default birimleri yükle
    if (activeIds == null) {
      setState(() {
        _units = List<UnitModel>.from(DefaultUnits.units);
      });
      return;
    }

    // Onboarding sonucu varsa → sadece aktif olanları işaretle
    List<UnitModel> updated = DefaultUnits.units.map((unit) {
      return unit.copyWith(isActive: activeIds.contains(unit.id));
    }).toList();

    setState(() {
      _units = updated;
    });
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
        onTap: (i) => setState(() => _currentIndex = i),
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
