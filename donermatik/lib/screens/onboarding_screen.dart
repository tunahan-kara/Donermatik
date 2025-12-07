import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/unit_model.dart';

class OnboardingScreen extends StatefulWidget {
  final List<UnitModel> units;
  final void Function(List<UnitModel>) onUnitsSelected;

  const OnboardingScreen({
    super.key,
    required this.units,
    required this.onUnitsSelected,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<UnitModel> tempUnits;

  @override
  void initState() {
    super.initState();
    tempUnits = List<UnitModel>.from(widget.units);
  }

  Future<void> _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // onboarding tamamlandı
    await prefs.setBool("onboarding_completed", true);

    // aktif birimlerin ID'lerini kaydet
    List<String> activeUnitIds = tempUnits
        .where((u) => u.isActive)
        .map((u) => u.id)
        .toList();

    await prefs.setStringList("active_units", activeUnitIds);

    widget.onUnitsSelected(tempUnits);

    Navigator.of(context).pushReplacementNamed("/main");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text("Birim Seçimi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hangi birimleri açmak istersin?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: tempUnits.length,
                itemBuilder: (context, index) {
                  final unit = tempUnits[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              unit.icon,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              unit.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: unit.isActive,
                          onChanged: (value) {
                            setState(() {
                              tempUnits[index] = unit.copyWith(isActive: value);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finishOnboarding,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Devam Et", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
