import 'package:flutter/material.dart';
import '../models/unit_model.dart';

class HomeScreen extends StatefulWidget {
  final List<UnitModel> units;

  const HomeScreen({super.key, required this.units});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController priceController = TextEditingController();
  double? enteredPrice;

  @override
  Widget build(BuildContext context) {
    final activeUnits = widget.units.where((u) => u.isActive).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Dönermatik")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // INPUT FIELD
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter price (TL)",
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  enteredPrice = double.tryParse(value);
                });
              },
            ),

            const SizedBox(height: 20),

            // UNIT LIST
            Expanded(
              child: ListView.builder(
                itemCount: activeUnits.length,
                itemBuilder: (context, index) {
                  final unit = activeUnits[index];

                  double? result = enteredPrice == null
                      ? null
                      : enteredPrice! / unit.price;

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
                              unit.icon,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unit.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "1 ${unit.name} = ${unit.price.toStringAsFixed(0)} TL",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Text(
                          result == null ? "-" : "${result.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                          ),
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
