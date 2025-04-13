import 'package:test/test.dart';
import '../lib/models/character.dart';
import '../lib/models/enums.dart';
import '../lib/models/magic_item.dart';
import '../lib/services/character_service.dart';

void main() {
  group('testes do modelo character', () {
    test('criar personagem com atributos validos', () {
      final character = Character.create(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoeses',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      expect(character.id, '1');
      expect(character.name, 'Joao');
      expect(character.adventurerName, 'Matador de dragoes');
      expect(character.characterClass, CharacterClass.guerreiro);
      expect(character.level, 1);
      expect(character.baseForce, 7);
      expect(character.baseDefense, 3);
      expect(character.items, isEmpty);
    });

    test('dar erro quando forsa e defesa passa de 10 pontos', () {
      expect(
        () => Character.create(
          id: '1',
          name: 'Joao',
          adventurerName: 'Matador de dragoes',
          characterClass: CharacterClass.guerreiro,
          level: 1,
          baseForce: 8,
          baseDefense: 3,
        ),
        throwsArgumentError,
      );
    });

    test('calcular total de forsa e defesa com itens', () {
      final character = Character.create(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 5,
        baseDefense: 5,
      );

      final weapon = MagicItem.create(
        id: 'espada1',
        name: 'Esperda',
        type: ItemType.arma,
        force: 3,
        defense: 0,
      );

      final armor = MagicItem.create(
        id: 'armadura1',
        name: 'Armaudra',
        type: ItemType.armadura,
        force: 0,
        defense: 2,
      );

      character.addItem(weapon);
      character.addItem(armor);

      expect(character.totalForce, 8);
      expect(character.totalDefense, 7);
    });

    test('permitir so um amuleto', () {
      final character = Character.create(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 5,
        baseDefense: 5,
      );

      final amulet1 = MagicItem.create(
        id: 'amuleto1',
        name: 'Amuletto 1',
        type: ItemType.amuleto,
        force: 1,
        defense: 1,
      );

      final amulet2 = MagicItem.create(
        id: 'amuleto2',
        name: 'Amuletto 2',
        type: ItemType.amuleto,
        force: 1,
        defense: 1,
      );

      character.addItem(amulet1);
      expect(() => character.addItem(amulet2), throwsArgumentError);
    });
  });

  group('testes do servico character', () {
    late CharacterService service;

    setUp(() {
      service = CharacterService();
    });

    test('criar e pegar personagem', () {
      final character = service.createCharacter(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matadro de Dragões',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      final retrieved = service.getCharacterById('1');
      expect(retrieved, equals(character));
    });

    test('dar erro quando criar personagem com id duplicado', () {
      service.createCharacter(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      expect(
        () => service.createCharacter(
          id: '1',
          name: 'Maria',
          adventurerName: 'Maga',
          characterClass: CharacterClass.mago,
          level: 1,
          baseForce: 5,
          baseDefense: 5,
        ),
        throwsArgumentError,
      );
    });

    test('atualizar atributros de um personagem', () {
      service.createCharacter(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      final updated = service.updateCharacter(
        id: '1',
        name: 'Joao Atualizadoo',
        adventurerName: 'Matador de dragoes Pro',
        level: 2,
      );

      expect(updated.name, 'Joao Atualizadoo');
      expect(updated.adventurerName, 'Matador de dragoes Pro');
      expect(updated.level, 2);
    });

    test('deletar personagem', () {
      service.createCharacter(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      service.deleteCharacter('1');
      expect(() => service.getCharacterById('1'), throwsArgumentError);
    });

    test('gerenciar itens do personagem', () {
      service.createCharacter(
        id: '1',
        name: 'Joao',
        adventurerName: 'Matador de dragoes',
        characterClass: CharacterClass.guerreiro,
        level: 1,
        baseForce: 7,
        baseDefense: 3,
      );

      final item = MagicItem.create(
        id: 'espada1',
        name: 'Esperda',
        type: ItemType.arma,
        force: 3,
        defense: 0,
      );

      service.addItemToCharacter('1', item);
      expect(service.getCharacterItems('1'), contains(item));

      service.removeItemFromCharacter('1', 'espada1');
      expect(service.getCharacterItems('1'), isEmpty);
    });
  });
}