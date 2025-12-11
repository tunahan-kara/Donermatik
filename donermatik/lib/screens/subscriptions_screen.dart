import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../models/unit_model.dart';
import '../utils/storage_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme.dart';

class SubscriptionsScreen extends StatefulWidget {
  final List<SubscriptionModel> subscriptions;
  final void Function(List<SubscriptionModel>) onSubscriptionsChanged;
  final List<UnitModel> units;

  const SubscriptionsScreen({
    super.key,
    required this.subscriptions,
    required this.onSubscriptionsChanged,
    required this.units,
  });

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  late List<SubscriptionModel> localSubs;

  @override
  void initState() {
    super.initState();
    localSubs = List<SubscriptionModel>.from(widget.subscriptions);
  }

  double get totalPrice => localSubs.fold(0.0, (sum, s) => sum + s.price);

  List<UnitModel> get activeUnits =>
      widget.units.where((u) => u.isActive).toList();

  Future<void> _saveSubs() async {
    final maps = localSubs.map((s) => s.toMap()).toList();
    await StorageService.saveSubscriptions(maps);
    widget.onSubscriptionsChanged(localSubs);
  }

  // ----------------------------------------------------------
  // INPUT (PREMIUM)
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
  // ADD SUBSCRIPTION (PREMIUM)
  // ----------------------------------------------------------
  void _openAddDialog() {
    TextEditingController nameC = TextEditingController();
    TextEditingController priceC = TextEditingController();
    TextEditingController iconC = TextEditingController(text: "💳");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "Yeni Abonelik Ekle",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Abonelik Adı", nameC),
            _input("Fiyat (TL/ay)", priceC, number: true),
            _input("Emoji / İkon", iconC),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("İptal", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Ekle",
              style: TextStyle(color: AppColors.accent),
            ),
            onPressed: () async {
              final name = nameC.text.trim();
              final price = double.tryParse(priceC.text) ?? 0;
              final icon = iconC.text.trim().isEmpty ? "💳" : iconC.text.trim();

              if (name.isEmpty || price <= 0) {
                Navigator.pop(context);
                return;
              }

              final newSub = SubscriptionModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                price: price,
                icon: icon,
              );

              setState(() => localSubs.add(newSub));

              await _saveSubs();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // EDIT SUBSCRIPTION (PREMIUM)
  // ----------------------------------------------------------
  void _openEditDialog(SubscriptionModel sub) {
    TextEditingController nameC = TextEditingController(text: sub.name);
    TextEditingController priceC = TextEditingController(
      text: sub.price.toString(),
    );
    TextEditingController iconC = TextEditingController(text: sub.icon);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(
          "${sub.name} Düzenle",
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Abonelik Adı", nameC),
            _input("Fiyat (TL/ay)", priceC, number: true),
            _input("Emoji / İkon", iconC),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                setState(() => localSubs.removeWhere((s) => s.id == sub.id));
                await _saveSubs();
              },
              child: const Text("Aboneliği Sil"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("İptal", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Kaydet",
              style: TextStyle(color: AppColors.accent),
            ),
            onPressed: () async {
              final newName = nameC.text.trim().isEmpty ? sub.name : nameC.text;
              final newPrice = double.tryParse(priceC.text) ?? sub.price;
              final newIcon = iconC.text.trim().isEmpty ? sub.icon : iconC.text;

              final updated = sub.copyWith(
                name: newName,
                price: newPrice,
                icon: newIcon,
              );

              setState(() {
                localSubs = localSubs.map((s) {
                  if (s.id == sub.id) return updated;
                  return s;
                }).toList();
              });

              await _saveSubs();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CONVERSIONS CARD
  // ----------------------------------------------------------
  Widget _buildConversions() {
    if (activeUnits.isEmpty) {
      return const Text(
        "Hiç aktif birim yok.",
        style: TextStyle(color: Colors.white70, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Birim Karşılıkları:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        ...activeUnits.map((u) {
          double val = totalPrice / u.price;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              "${u.icon} ${u.name}: ${val.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, color: AppColors.accent),
            ),
          );
        }),
      ],
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonelikler"),
        centerTitle: true,
        backgroundColor: AppColors.backgroundDark,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ----------------------------------------------------------
            // TOP SUMMARY CARD
            // ----------------------------------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Aylık Toplam",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${totalPrice.toStringAsFixed(2)} TL",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  _buildConversions(),
                ],
              ),
            ),

            // ----------------------------------------------------------
            // ADD BUTTON
            // ----------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openAddDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Yeni Abonelik Ekle"),
              ),
            ),

            const SizedBox(height: 16),

            // ----------------------------------------------------------
            // SUBSCRIPTIONS LIST
            // ----------------------------------------------------------
            Expanded(
              child: localSubs.isEmpty
                  ? const Center(
                      child: Text(
                        "Henüz abonelik eklenmedi.",
                        style: TextStyle(color: Colors.white60),
                      ),
                    )
                  : ListView.builder(
                      itemCount: localSubs.length,
                      itemBuilder: (context, index) {
                        final sub = localSubs[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: AppTheme.cardDecoration(),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    sub.icon,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "${sub.price.toStringAsFixed(2)} TL / ay",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),

                                      const SizedBox(height: 4),
                                      ...activeUnits.map((u) {
                                        double v = sub.price / u.price;
                                        return Text(
                                          "~${v.toStringAsFixed(2)} ${u.name}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.accent,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.accent,
                                ),
                                onPressed: () => _openEditDialog(sub),
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
