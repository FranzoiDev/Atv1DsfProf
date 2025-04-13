import 'package:test/test.dart';
import '../lib/models/magic_item.dart';
import '../lib/models/enums.dart';
import '../lib/services/magic_item_service.dart';

void main() {
  group('testes do modelo magic item', () {
    test('criar arma com atributos validos', () {
      final weapon = MagicItem.create(
        id: 'espada1',
        name: 'Espada Mata Drago',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      expect(weapon.id, 'espada1');
      expect(weapon.name, 'Esperda Mata Drago');
      expect(weapon.type, ItemType.arma);
      expect(weapon.force, 5);
      expect(weapon.defense, 0);
    });

    test('criar armadura com atributos validos', () {
      final armor = MagicItem.create(
        id: 'armadura1',
        name: 'Armadura de Escams de Dragão',
        type: ItemType.armadura,
        force: 0,
        defense: 4,
      );

      expect(armor.id, 'armadura1');
      expect(armor.name, 'Armadura de Escams de Dragão');
      expect(armor.type, ItemType.armadura);
      expect(armor.force, 0);
      expect(armor.defense, 4);
    });

    test('criar amuleto com atributos validos', () {
      final amulet = MagicItem.create(
        id: 'amuleto1',
        name: 'Amuletto Coraçao de Dragao',
        type: ItemType.amuleto,
        force: 2,
        defense: 2,
      );

      expect(amulet.id, 'amuleto1');
      expect(amulet.name, 'Amuletto Coraçao de Dragao');
      expect(amulet.type, ItemType.amuleto);
      expect(amulet.force, 2);
      expect(amulet.defense, 2);
    });

    test('dar erro quando arma tem defesa', () {
      expect(
        () => MagicItem.create(
          id: 'espada1',
          name: 'Espada',
          type: ItemType.arma,
          force: 5,
          defense: 1,
        ),
        throwsArgumentError,
      );
    });

    test('dar erro quando armadura tem forsa', () {
      expect(
        () => MagicItem.create(
          id: 'armaudra1',
          name: 'Armaudra',
          type: ItemType.armadura,
          force: 1,
          defense: 4,
        ),
        throwsArgumentError,
      );
    });

    test('dar erro quando atributos maior q o maximo', () {
      expect(
        () => MagicItem.create(
          id: 'item1',
          name: 'Item',
          type: ItemType.amuleto,
          force: 11,
          defense: 0,
        ),
        throwsArgumentError,
      );
    });

    test('dar erro quando os dois atributos sao zero', () {
      expect(
        () => MagicItem.create(
          id: 'item1',
          name: 'Item',
          type: ItemType.amuleto,
          force: 0,
          defense: 0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('testes do servico magic item', () {
    late MagicItemService service;

    setUp(() {
      service = MagicItemService();
    });

    test('criar e pegar item', () {
      final item = service.createItem(
        id: 'espada1',
        name: 'Espada',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      final retrieved = service.getItemById('espada1');
      expect(retrieved, equals(item));
    });

    test('dar erro quando criar item com id duplicado', () {
      service.createItem(
        id: 'espada1',
        name: 'Espada',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      expect(
        () => service.createItem(
          id: 'espada1',
          name: 'Outra Esperda',
          type: ItemType.arma,
          force: 3,
          defense: 0,
        ),
        throwsArgumentError,
      );
    });

    test('atualizar atributos do item', () {
      service.createItem(
        id: 'espada1',
        name: 'Espada',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      final updated = service.updateItem(
        id: 'espada1',
        name: 'Espada Melhoreda',
        force: 7,
      );

      expect(updated.name, 'Espada Melhoreda');
      expect(updated.force, 7);
      expect(updated.defense, 0);
    });

    test('deletar item', () {
      service.createItem(
        id: 'espada1',
        name: 'Espada',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      service.deleteItem('espada1');
      expect(() => service.getItemById('espada1'), throwsArgumentError);
    });

    test('listar todos os itens', () {
      final sword = service.createItem(
        id: 'espada1',
        name: 'Espada',
        type: ItemType.arma,
        force: 5,
        defense: 0,
      );

      final armor = service.createItem(
        id: 'armadura1',
        name: 'Armadura',
        type: ItemType.armadura,
        force: 0,
        defense: 4,
      );

      final items = service.getAllItems();
      expect(items, containsAll([sword, armor]));
    });
  });
}