class FeedbackGenerator {
  static String generate(String categoryId, double amount) {
    switch (categoryId) {
      case "cafe":
        return "Bir latte daha mı? Aga sen baristalara çalışıyorsun herhalde 😭☕";

      case "market":
        return "Pazara çıkmışsın belli… 400 TL gitmiş ama poşette bir şey yok gibi 😭";

      case "entertainment":
        return "Steam indirimleri yakalamış seni 🔥🎮";

      case "transport":
        return "Otobüs kartı senden benden fazla geziyor artık.";

      case "rent":
        return "Kira… canımızı yakan ilk harcama. Sabırlı ol aga.";

      default:
        return "Bu harcama = ${amount.toStringAsFixed(0)} TL. Cüzdan bir seni seviyor bir beni.";
    }
  }
}
