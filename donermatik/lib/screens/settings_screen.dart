import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../utils/storage_service.dart';
import '../utils/default_units.dart';
import '../theme/app_theme.dart';

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

  // ----------------------------------------------------------
  //  INPUT WIDGET (PREMIUM)
  // ----------------------------------------------------------
  Widget _input(String label, TextEditingController c, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.accent),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //   YENİ BİRİM EKLEME DİYALOĞU (TÜRKÇE + PREMIUM)
  // ----------------------------------------------------------
  void _openAddUnitDialog() {
    TextEditingController nameC = TextEditingController();
    TextEditingController priceC = TextEditingController();
    TextEditingController iconC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Yeni Birim Ekle",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Birim Adı", nameC),
            _input("Fiyat (TL)", priceC, number: true),
            _input("Emoji / İkon", iconC),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              if (nameC.text.trim().isEmpty ||
                  priceC.text.trim().isEmpty ||
                  iconC.text.trim().isEmpty) {
                Navigator.pop(context);
                return;
              }

              UnitModel newUnit = UnitModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameC.text,
                price: double.parse(priceC.text),
                icon: iconC.text,
                isActive: true,
              );

              setState(() => localUnits.add(newUnit));

              await _saveCustomUnits();
              widget.onUnitsChanged(localUnits);
              Navigator.pop(context);
            },
            child: const Text(
              "Ekle",
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //  BİRİM DÜZENLEME (SİLME + PREMIUM)
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //  BİRİM DÜZENLEME (İSİM + FİYAT + EMOJI + SİLME)
  // ----------------------------------------------------------
  void _editUnit(UnitModel unit) {
    TextEditingController nameC = TextEditingController(text: unit.name);
    TextEditingController priceC = TextEditingController(
      text: unit.price.toString(),
    );
    TextEditingController iconC = TextEditingController(text: unit.icon);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(
          "${unit.name} Düzenle",
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Birim Adı", nameC),
            _input("Fiyat (TL)", priceC, number: true),
            _input("Emoji / İkon", iconC),

            const SizedBox(height: 14),

            if (!_isDefault(unit))
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteCustom(unit);
                },
                child: const Text("Birim Sil"),
              ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("İptal", style: TextStyle(color: Colors.white60)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Kaydet",
              style: TextStyle(color: AppColors.accent),
            ),
            onPressed: () async {
              final newName = nameC.text.trim();
              final newPrice = double.tryParse(priceC.text) ?? unit.price;
              final newIcon = iconC.text.trim().isEmpty
                  ? unit.icon
                  : iconC.text.trim();

              if (newName.isEmpty) {
                Navigator.pop(context);
                return;
              }

              // Fiyatı kaydet
              await StorageService.saveUnitPrice(unit.id, newPrice);

              // Yerel listeyi güncelle
              setState(() {
                localUnits = localUnits.map((u) {
                  if (u.id == unit.id) {
                    return u.copyWith(
                      name: newName,
                      price: newPrice,
                      icon: newIcon,
                    );
                  }
                  return u;
                }).toList();
              });

              await _saveCustomUnits();
              widget.onUnitsChanged(localUnits);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //   SİLME
  // ----------------------------------------------------------
  void _deleteCustom(UnitModel unit) async {
    setState(() => localUnits.remove(unit));
    await _saveCustomUnits();
    widget.onUnitsChanged(localUnits);
  }

  // ----------------------------------------------------------
  //   TÜM CUSTOM BİRİMLERİ KAYDET
  // ----------------------------------------------------------
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

  // ----------------------------------------------------------
  //   AKTİF/PASİF (TOGGLE)
  // ----------------------------------------------------------
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

  // ----------------------------------------------------------
  //   BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Birim Ayarları"),
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------------------------------
            //   YENİ BİRİM EKLEME BUTONU
            // -------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(14),
              child: ElevatedButton(
                onPressed: _openAddUnitDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Yeni Birim Ekle"),
              ),
            ),

            const SizedBox(height: 16),

            // -------------------------------
            //   BİRİM LİSTESİ
            // -------------------------------
            Expanded(
              child: ListView.builder(
                itemCount: localUnits.length,
                itemBuilder: (context, index) {
                  final u = localUnits[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppTheme.cardDecoration(),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(u.icon, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Text(
                              u.name,
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Switch(
                              value: u.isActive,
                              onChanged: (v) => _toggle(u, v),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.accent,
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
