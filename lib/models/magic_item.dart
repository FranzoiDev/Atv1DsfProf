import 'enums.dart';

class MagicItem {
  final String id;
  final String name;
  final ItemType type;
  final int force;
  final int defense;

  MagicItem._({
    required this.id,
    required this.name,
    required this.type,
    required this.force,
    required this.defense,
  });

  factory MagicItem.create({
    required String id,
    required String name,
    required ItemType type,
    required int force,
    required int defense,
  }) {
    _validateAttributes(type, force, defense);
    return MagicItem._(
      id: id,
      name: name,
      type: type,
      force: force,
      defense: defense,
    );
  }

  static void _validateAttributes(ItemType type, int force, int defense) {
    if (force < 0 || defense < 0) {
      throw ArgumentError('Forca e defesa não podem ser negativas');
    }

    if (force > 10 || defense > 10) {
      throw ArgumentError('Forca e defesa não podem ser maiores que 10');
    }

    if (force == 0 && defense == 0) {
      throw ArgumentError('Item nao pode ter forca e defesa iguais a zero');
    }

    switch (type) {
      case ItemType.arma:
        if (defense != 0) {
          throw ArgumentError('Armas devem ter defesa como zero');
        }
        break;
      case ItemType.armadura:
        if (force != 0) {
          throw ArgumentError('Armaduras devem ter força como zero');
        }
        break;
      case ItemType.amuleto:
        break;
    }
  }

  @override
  String toString() {
    return 'ItemMagico(id: $id, nome: $name, tipo: $type, forca: $force, defesa: $defense)';
  }
}