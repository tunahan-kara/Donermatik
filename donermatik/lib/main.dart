import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/unit_model.dart';
import 'models/subscription_model.dart';
import 'utils/default_units.dart';
import 'utils/storage_service.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/subscriptions_screen.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FULLSCREEN
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const DonermatikApp());
}

class DonermatikApp extends StatelessWidget {
  const DonermatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dönermatik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoadingScreen(),
    );
  }
}

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
    done = prefs.getBool('onboarding_completed') ?? false;
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

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  List<UnitModel> units = List<UnitModel>.from(DefaultUnits.units);

  void _updateUnits(List<UnitModel> updated) {
    setState(() => units = updated);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(units: units, onUnitsSelected: _updateUnits);
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  List<UnitModel> units = [];
  List<SubscriptionModel> subs = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await _loadUnits();
    await _loadSubs();
  }

  Future<void> _loadUnits() async {
    List<UnitModel> finalUnits = [];
    final activeIds = await StorageService.loadActiveUnits();

    // default units
    for (var u in DefaultUnits.units) {
      final savedPrice = await StorageService.loadUnitPrice(u.id);
      finalUnits.add(
        u.copyWith(
          price: savedPrice ?? u.price,
          isActive: activeIds?.contains(u.id) ?? true,
        ),
      );
    }

    // custom units
    final customMaps = await StorageService.loadCustomUnits();
    for (var m in customMaps) {
      finalUnits.add(
        UnitModel(
          id: m['id'],
          name: m['name'],
          price: double.parse(m['price']),
          icon: m['icon'],
          isActive: m['isActive'] == 'true',
        ),
      );
    }

    setState(() => units = finalUnits);
  }

  Future<void> _loadSubs() async {
    final maps = await StorageService.loadSubscriptions();
    final loaded = maps.map((m) => SubscriptionModel.fromMap(m)).toList();
    setState(() => subs = loaded);
  }

  void _updateUnits(List<UnitModel> newUnits) {
    setState(() => units = newUnits);
  }

  void _updateSubs(List<SubscriptionModel> newSubs) {
    setState(() => subs = newSubs);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(units: units),
      SubscriptionsScreen(
        subscriptions: subs,
        onSubscriptionsChanged: _updateSubs,
        units: units,
      ),
      SettingsScreen(units: units, onUnitsChanged: _updateUnits),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Hesapla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.autorenew),
            label: 'Abonelikler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Ayarlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
