import '../models/unit_model.dart';

class DefaultUnits {
  static List<UnitModel> units = [
    UnitModel(
      id: 'doner',
      name: 'Döner',
      price: 120.0, // 1 porsiyon döner = 120 TL (örnek)
      icon: '🥙',
    ),
    UnitModel(
      id: 'cigarette',
      name: 'Sigara',
      price: 70.0, // 1 paket sigara
      icon: '🚬',
    ),
    UnitModel(
      id: 'tea',
      name: 'Çay',
      price: 10.0, // 1 bardak çay
      icon: '☕',
    ),
    UnitModel(id: 'simit', name: 'Simit', price: 12.0, icon: '🥐'),
  ];
}
