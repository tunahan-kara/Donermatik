import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../utils/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final List<UnitModel> units;
  final void Function(List<UnitModel>) onUnitsChanged;

  const SettingsScreen({
    super.key,
    required this.units,
    required this.onUnitsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<UnitModel> localUnits;

  @override
  void initState() {
    super.initState();
    localUnits = List<UnitModel>.from(widget.units);
  }

  // Fiyat düzenleme popup'ı
  void _editPrice(UnitModel unit) {
    TextEditingController controller = TextEditingController(
      text: unit.price.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text("Edit ${unit.name} Price"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "New price (TL)",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                double newPrice =
                    double.tryParse(controller.text) ?? unit.price;

                // Fiyatı kaydet
                await StorageService.saveUnitPrice(unit.id, newPrice);

                // Local listeyi güncelle
                setState(() {
                  localUnits = localUnits.map((u) {
                    if (u.id == unit.id) {
                      return u.copyWith(price: newPrice);
                    }
                    return u;
                  }).toList();
                });

                // Ana state'i güncelle
                widget.onUnitsChanged(localUnits);

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Toggle değişimi
  void _toggleActive(UnitModel unit, bool newValue) async {
    setState(() {
      localUnits = localUnits.map((u) {
        if (u.id == unit.id) {
          return u.copyWith(isActive: newValue);
        }
        return u;
      }).toList();
    });

    // aktif birimleri kaydet
    final activeIds = localUnits
        .where((u) => u.isActive)
        .map((u) => u.id)
        .toList();
    await StorageService.saveActiveUnits(activeIds);

    widget.onUnitsChanged(localUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: localUnits.length,
        itemBuilder: (context, index) {
          final unit = localUnits[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // icon + name
                Row(
                  children: [
                    Text(unit.icon, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 12),
                    Text(unit.name, style: const TextStyle(fontSize: 17)),
                  ],
                ),

                // switch + edit button
                Row(
                  children: [
                    Switch(
                      value: unit.isActive,
                      onChanged: (val) => _toggleActive(unit, val),
                    ),
                    IconButton(
                      onPressed: () => _editPrice(unit),
                      icon: const Icon(Icons.edit, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
