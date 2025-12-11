import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final int activeUnitCount;
  final int subscriptionCount;

  const ProfileScreen({
    super.key,
    required this.activeUnitCount,
    required this.subscriptionCount,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Varsayılan avatar ve isim
  String avatar = "😎";
  String userName = "Kullanıcı";

  // Avatar seçenekleri
  final List<String> avatars = ["😎", "🥸", "🤠", "🤓", "🐸", "🦊", "🐵"];

  // ----------------------------------------------------------
  // İSİM DEĞİŞTİRME DİYALOĞU
  // ----------------------------------------------------------
  void _changeName() {
    TextEditingController nameC = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          "İsmini Değiştir",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameC,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Yeni İsim",
            labelStyle: TextStyle(color: Colors.white60),
          ),
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
            onPressed: () {
              if (nameC.text.trim().isNotEmpty) {
                setState(() => userName = nameC.text.trim());
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // AVATAR SEÇME SHEET
  // ----------------------------------------------------------
  void _chooseAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Avatar Seç",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: avatars.map((a) {
                return GestureDetector(
                  onTap: () {
                    setState(() => avatar = a);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                      border: Border.all(
                        color: a == avatar ? AppColors.accent : Colors.white24,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(a, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SAYFA
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------
            //  PROFIL KARTI
            // -------------------------------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar bubble
                  GestureDetector(
                    onTap: _chooseAvatar,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.accent, AppColors.accentDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(avatar, style: const TextStyle(fontSize: 34)),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name + Edit Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      GestureDetector(
                        onTap: _changeName,
                        child: const Text(
                          "İsmi düzenle",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            //  HIZLI İSTATİSTİK KARTLARI
            // -------------------------------------------------------
            const Text(
              "Özet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: AppTheme.cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.calculate_outlined,
                          size: 32,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Aktif Birimler",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.activeUnitCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: AppTheme.cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.autorenew,
                          size: 32,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Abonelik Sayısı",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.subscriptionCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            //  YAKINDA ÖZELLİKLER
            // -------------------------------------------------------
            Container(
              decoration: AppTheme.cardDecoration(),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Yakında Gelecek Özellikler",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Rozetler ve başarı sistemi 🏅",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    "• Profil kişiselleştirme seçenekleri ✨",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    "• Aylık / yıllık harcama analizleri 📊",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
