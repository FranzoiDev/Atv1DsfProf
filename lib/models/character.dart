import 'enums.dart';
import 'magic_item.dart';

class Character {
  final String id;
  final String name;
  final String adventurerName;
  final CharacterClass characterClass;
  final int level;
  final List<MagicItem> items;
  final int baseForce;
  final int baseDefense;

  Character._({
    required this.id,
    required this.name,
    required this.adventurerName,
    required this.characterClass,
    required this.level,
    required this.items,
    required this.baseForce,
    required this.baseDefense,
  });

  factory Character.create({
    required String id,
    required String name,
    required String adventurerName,
    required CharacterClass characterClass,
    required int level,
    required int baseForce,
    required int baseDefense,
  }) {
    _validateAttributes(baseForce, baseDefense);

    return Character._(
      id: id,
      name: name,
      adventurerName: adventurerName,
      characterClass: characterClass,
      level: level,
      items: [],
      baseForce: baseForce,
      baseDefense: baseDefense,
    );
  }

  static void _validateAttributes(int force, int defense) {
    if (force < 0 || defense < 0) {
      throw ArgumentError('Foça e defesa não podem ser negativas');
    }

    if (force + defense > 10) {
      throw ArgumentError(
        'Total de ponto de força e defesa não pode ser maior que 10',
      );
    }
  }

  int get totalForce =>
      baseForce + items.fold(0, (sum, item) => sum + item.force);
  int get totalDefense =>
      baseDefense + items.fold(0, (sum, item) => sum + item.defense);

  bool canAddItem(MagicItem item) {
    if (item.type == ItemType.amuleto) {
      return !items.any((i) => i.type == ItemType.amuleto);
    }
    return true;
  }

  void addItem(MagicItem item) {
    if (!canAddItem(item)) {
      throw ArgumentError('Não é possível adicionar mais de um amuleto');
    }
    items.add(item);
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
  }

  MagicItem? getAmulet() {
    return items.firstWhere(
      (item) => item.type == ItemType.amuleto,
      orElse: () => throw StateError('Amuleto não encontrado'),
    );
  }

  @override
  String toString() {
    return 'Personagem(id: $id, nome: $name, nomeAventureiro: $adventurerName, '
        'classe: $characterClass, nível: $level, forçaTotal: $totalForce, '
        'defesaTotal: $totalDefense)';
  }
}
