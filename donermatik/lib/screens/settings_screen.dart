import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../utils/storage_service.dart';
import '../utils/default_units.dart';

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

  bool _isDefault(UnitModel u) => DefaultUnits.units.any((d) => d.id == u.id);

  // ADD CUSTOM UNIT
  void _openAddUnitDialog() {
    TextEditingController nameC = TextEditingController();
    TextEditingController priceC = TextEditingController();
    TextEditingController iconC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Add Custom Unit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Unit Name", nameC),
            _input("Price (TL)", priceC, number: true),
            _input("Emoji/Icon", iconC),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              UnitModel newUnit = UnitModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameC.text,
                price: double.parse(priceC.text),
                icon: iconC.text,
                isActive: true,
              );

              setState(() {
                localUnits.add(newUnit);
              });

              await _saveCustomUnits();
              widget.onUnitsChanged(localUnits);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // REUSABLE INPUT
  Widget _input(String label, TextEditingController c, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
        ),
      ),
    );
  }

  // EDIT PRICE + DELETE
  void _editUnit(UnitModel unit) {
    TextEditingController priceC = TextEditingController(
      text: unit.price.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("Edit ${unit.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Price (TL)", priceC, number: true),
            if (!_isDefault(unit))
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteCustom(unit);
                },
                child: const Text("Delete Unit"),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              double p = double.parse(priceC.text);

              await StorageService.saveUnitPrice(unit.id, p);

              setState(() {
                localUnits = localUnits.map((u) {
                  if (u.id == unit.id) return u.copyWith(price: p);
                  return u;
                }).toList();
              });

              widget.onUnitsChanged(localUnits);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // DELETE
  void _deleteCustom(UnitModel unit) async {
    setState(() {
      localUnits.remove(unit);
    });

    await _saveCustomUnits();
    widget.onUnitsChanged(localUnits);
  }

  // SAVE ALL CUSTOM UNITS
  Future<void> _saveCustomUnits() async {
    List<Map<String, dynamic>> custom = localUnits
        .where((u) => !_isDefault(u))
        .map(
          (u) => {
            "id": u.id,
            "name": u.name,
            "price": u.price.toString(),
            "icon": u.icon,
            "isActive": u.isActive.toString(),
          },
        )
        .toList();

    await StorageService.saveCustomUnits(custom);
  }

  // TOGGLE
  void _toggle(UnitModel u, bool v) async {
    setState(() {
      localUnits = localUnits.map((x) {
        if (x.id == u.id) return x.copyWith(isActive: v);
        return x;
      }).toList();
    });

    List<String> active = localUnits
        .where((x) => x.isActive)
        .map((x) => x.id)
        .toList();

    await StorageService.saveActiveUnits(active);
    widget.onUnitsChanged(localUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _openAddUnitDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Add Custom Unit"),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: localUnits.length,
                itemBuilder: (context, index) {
                  final u = localUnits[index];

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
                        Row(
                          children: [
                            Text(u.icon, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 10),
                            Text(u.name, style: const TextStyle(fontSize: 17)),
                          ],
                        ),

                        // SWITCH + EDIT
                        Row(
                          children: [
                            Switch(
                              value: u.isActive,
                              onChanged: (v) => _toggle(u, v),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () => _editUnit(u),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
