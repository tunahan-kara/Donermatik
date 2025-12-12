import '../models/unit_model.dart';

class DefaultUnits {
  static List<UnitModel> units = [
    UnitModel(
      id: 'doner',
      name: 'Döner',
      price: 180.0, // 1 porsiyon döner = 180 TL (örnek)
      icon: '🥙',
    ),
    UnitModel(
      id: 'cigarette',
      name: 'Sigara',
      price: 95.0, // 1 paket sigara
      icon: '🚬',
    ),
    UnitModel(
      id: 'tea',
      name: 'Çay',
      price: 40.0, // 1 bardak çay
      icon: '☕',
    ),
    UnitModel(id: 'simit', name: 'Simit', price: 30.0, icon: '🥐'),
  ];
}
