import '../models/magic_item.dart';
import '../models/enums.dart';

class MagicItemService {
  final Map<String, MagicItem> _items = {};

  MagicItem createItem({
    required String id,
    required String name,
    required ItemType type,
    required int force,
    required int defense,
  }) {
    if (_items.containsKey(id)) {
      throw ArgumentError('Item com ID $id já existe');
    }

    final item = MagicItem.create(
      id: id,
      name: name,
      type: type,
      force: force,
      defense: defense,
    );

    _items[id] = item;
    return item;
  }

  List<MagicItem> getAllItems() {
    return _items.values.toList();
  }

  MagicItem getItemById(String id) {
    final item = _items[id];
    if (item == null) {
      throw ArgumentError('Item com ID $id não encontrado');
    }
    return item;
  }

  MagicItem updateItem({
    required String id,
    String? name,
    ItemType? type,
    int? force,
    int? defense,
  }) {
    final existingItem = getItemById(id);

    final updatedItem = MagicItem.create(
      id: id,
      name: name ?? existingItem.name,
      type: type ?? existingItem.type,
      force: force ?? existingItem.force,
      defense: defense ?? existingItem.defense,
    );

    _items[id] = updatedItem;
    return updatedItem;
  }

  void deleteItem(String id) {
    if (!_items.containsKey(id)) {
      throw ArgumentError('Item com ID $id não encontrado');
    }
    _items.remove(id);
  }
}