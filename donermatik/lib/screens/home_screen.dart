import 'package:flutter/material.dart';
import '../models/unit_model.dart';

class HomeScreen extends StatefulWidget {
  final List<UnitModel> units;

  const HomeScreen({super.key, required this.units});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? entered;

  @override
  Widget build(BuildContext context) {
    List<UnitModel> active = widget.units.where((u) => u.isActive).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Dönermatik")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
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
              onChanged: (v) => setState(() => entered = double.tryParse(v)),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: active.length,
                itemBuilder: (context, i) {
                  final u = active[i];

                  double? result = (entered == null)
                      ? null
                      : entered! / u.price;

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
                            const SizedBox(width: 12),
                            Text(
                              u.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          result == null ? "-" : result.toStringAsFixed(2),
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
