import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../models/unit_model.dart';
import '../utils/storage_service.dart';

class SubscriptionsScreen extends StatefulWidget {
  final List<SubscriptionModel> subscriptions;
  final void Function(List<SubscriptionModel>) onSubscriptionsChanged;
  final List<UnitModel> units; // active units & prices

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

  double get totalPrice {
    return localSubs.fold(0.0, (sum, s) => sum + s.price);
  }

  List<UnitModel> get activeUnits {
    return widget.units.where((u) => u.isActive).toList();
  }

  Future<void> _saveSubs() async {
    List<Map<String, dynamic>> maps = localSubs.map((s) => s.toMap()).toList();
    await StorageService.saveSubscriptions(maps);
    widget.onSubscriptionsChanged(localSubs);
  }

  // -----------------------------
  // ADD SUBSCRIPTION
  // -----------------------------
  void _openAddDialog() {
    TextEditingController nameC = TextEditingController();
    TextEditingController priceC = TextEditingController();
    TextEditingController iconC = TextEditingController(text: "💳");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Add Subscription"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Name", nameC),
            _input("Price (TL/month)", priceC, number: true),
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
              final name = nameC.text.trim();
              final price = double.tryParse(priceC.text) ?? 0.0;
              final icon = iconC.text.trim().isEmpty ? "💳" : iconC.text.trim();

              if (name.isEmpty || price <= 0) {
                Navigator.pop(context);
                return;
              }

              final sub = SubscriptionModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                price: price,
                icon: icon,
              );

              setState(() {
                localSubs.add(sub);
              });

              await _saveSubs();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // EDIT SUBSCRIPTION
  // -----------------------------
  void _openEditDialog(SubscriptionModel sub) {
    TextEditingController nameC = TextEditingController(text: sub.name);
    TextEditingController priceC = TextEditingController(
      text: sub.price.toString(),
    );
    TextEditingController iconC = TextEditingController(text: sub.icon);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("Edit ${sub.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Name", nameC),
            _input("Price (TL/month)", priceC, number: true),
            _input("Emoji/Icon", iconC),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  localSubs.removeWhere((s) => s.id == sub.id);
                });
                await _saveSubs();
              },
              child: const Text("Delete Subscription"),
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
              final name = nameC.text.trim();
              final price = double.tryParse(priceC.text) ?? sub.price;
              final icon = iconC.text.trim().isEmpty
                  ? sub.icon
                  : iconC.text.trim();

              final updated = sub.copyWith(
                name: name.isEmpty ? sub.name : name,
                price: price,
                icon: icon,
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
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // INPUT FIELD
  // -----------------------------
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

  // -----------------------------
  // CALCULATE CONVERSIONS
  // -----------------------------
  Widget _buildConversions() {
    if (activeUnits.isEmpty) {
      return const Text(
        "No active units found.",
        style: TextStyle(color: Colors.grey, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Conversions:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        ...activeUnits.map((u) {
          double val = totalPrice / u.price;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              "${u.icon} ${u.name} → ${val.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, color: Colors.orange),
            ),
          );
        }),
      ],
    );
  }

  // -----------------------------
  // BUILD
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscriptions")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Monthly Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total: ${totalPrice.toStringAsFixed(2)} TL",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // MULTI-UNIT CONVERSION
                  _buildConversions(),
                ],
              ),
            ),

            // ADD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openAddDialog,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Add Subscription"),
              ),
            ),

            const SizedBox(height: 16),

            // LIST
            Expanded(
              child: localSubs.isEmpty
                  ? const Center(
                      child: Text(
                        "No subscriptions added yet.",
                        style: TextStyle(color: Colors.white60),
                      ),
                    )
                  : ListView.builder(
                      itemCount: localSubs.length,
                      itemBuilder: (context, index) {
                        final sub = localSubs[index];

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
                                  Text(
                                    sub.icon,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  const SizedBox(width: 10),
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
                                        "${sub.price.toStringAsFixed(2)} TL / month",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),

                                      // MULTI-UNIT CONVERSION PER SUB
                                      ...activeUnits.map((u) {
                                        double v = sub.price / u.price;
                                        return Text(
                                          "~${v.toStringAsFixed(2)} ${u.name}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange,
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
                                  color: Colors.orange,
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
