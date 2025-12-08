import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/unit_model.dart';
import 'utils/default_units.dart';
import 'utils/storage_service.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 TAM EKRAN - IMMERSIVE STICKY (KESİN ÇALIŞIR)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Üst bar tamamen yok
      systemNavigationBarColor: Colors.transparent, // Alt bar tamamen yok
    ),
  );

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
// LOADING SCREEN — onboarding tamam mı kontrol eder
//

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool? done;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    done = prefs.getBool("onboarding_completed") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (done == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return done! ? const MainNavigation() : const OnboardingWrapper();
  }
}

//
// ONBOARDING WRAPPER
//

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  List<UnitModel> units = List<UnitModel>.from(DefaultUnits.units);

  void _update(List<UnitModel> newList) {
    setState(() => units = newList);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(units: units, onUnitsSelected: _update);
  }
}

//
// ANA NAVİGASYON
//

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  List<UnitModel> units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    List<UnitModel> finalUnits = [];

    List<String>? activeIds = await StorageService.loadActiveUnits();

    // Default Units
    for (var u in DefaultUnits.units) {
      double? savedPrice = await StorageService.loadUnitPrice(u.id);

      finalUnits.add(
        u.copyWith(
          price: savedPrice ?? u.price,
          isActive: activeIds?.contains(u.id) ?? true,
        ),
      );
    }

    // Custom Units
    List<Map<String, dynamic>> customMaps =
        await StorageService.loadCustomUnits();

    for (var m in customMaps) {
      finalUnits.add(
        UnitModel(
          id: m["id"],
          name: m["name"],
          price: double.parse(m["price"]),
          icon: m["icon"],
          isActive: m["isActive"] == "true",
        ),
      );
    }

    setState(() => units = finalUnits);
  }

  void _updateUnits(List<UnitModel> newList) {
    setState(() => units = newList);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(units: units),
      SettingsScreen(units: units, onUnitsChanged: _updateUnits),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1A1A1A),
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calculate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
