import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/unit_model.dart';
import 'models/subscription_model.dart';

import 'utils/default_units.dart';
import 'utils/storage_service.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/subscriptions_screen.dart';

import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';

import 'screens/onboarding_welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FULL SCREEN MODE
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider()..loadSettings(),
      child: const DonermatikApp(),
    ),
  );
}

class DonermatikApp extends StatelessWidget {
  const DonermatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return MaterialApp(
      title: 'Dönermatik',
      debugShowCheckedModeBanner: false,
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoadingScreen(),

      routes: {"/main": (context) => const MainNavigation()},
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

    return done! ? const MainNavigation() : const OnboardingWelcomeScreen();
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

    for (var u in DefaultUnits.units) {
      final savedPrice = await StorageService.loadUnitPrice(u.id);
      finalUnits.add(
        u.copyWith(
          price: savedPrice ?? u.price,
          isActive: activeIds?.contains(u.id) ?? true,
        ),
      );
    }

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
      ProfileScreen(
        activeUnitCount: units.where((u) => u.isActive).length,
        subscriptionCount: subs.length,
      ),
    ];

    return Scaffold(
      body: pages[index],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          // 🔥 Ripple / parlama fabrikasını tamamen kapat
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark
              : AppColors.cardLight,

          currentIndex: index,
          onTap: (i) => setState(() => index = i),

          enableFeedback: false,
          showUnselectedLabels: true,

          // ✔ Smooth seçili efekt
          selectedIconTheme: const IconThemeData(
            size: 30,
            color: AppColors.accent,
          ),
          unselectedIconTheme: const IconThemeData(
            size: 24,
            color: Colors.grey,
          ),

          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),

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
      ),
    );
  }
}
