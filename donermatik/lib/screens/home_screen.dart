import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final List<UnitModel> units;

  const HomeScreen({super.key, required this.units});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? enteredAmount;

  @override
  Widget build(BuildContext context) {
    final activeUnits = widget.units.where((u) => u.isActive).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dönermatik')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ÜST BİLGİ KARTI
            Container(
              decoration: AppTheme.cardDecoration(soft: true),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Yuvarlak ikon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.currency_exchange_rounded,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paranı Çevir!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Seçriğin birimlerden kaç adet alabileceğini öğren!",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // GİRİŞ KARTI
            Container(
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ücret Gir (TL)",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: "Örneğin: 150",
                      prefixIcon: Icon(Icons.currency_lira),
                    ),
                    onChanged: (v) {
                      setState(() {
                        enteredAmount = double.tryParse(v.replaceAll(',', '.'));
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Aktif Birimler",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // DÖNÜŞÜM LİSTESİ
            Expanded(
              child: activeUnits.isEmpty
                  ? const Center(
                      child: Text(
                        "No active units. You can enable units in Settings.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: activeUnits.length,
                      itemBuilder: (context, index) {
                        final u = activeUnits[index];

                        double? result;
                        if (enteredAmount != null &&
                            enteredAmount != 0 &&
                            u.price > 0) {
                          result = enteredAmount! / u.price;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: AppTheme.cardDecoration(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Text(
                                u.icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "1 ${u.name} = ${u.price.toStringAsFixed(2)} TL",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                result == null
                                    ? "-"
                                    : result.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
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
