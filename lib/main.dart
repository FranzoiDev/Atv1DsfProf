import 'dart:io';
import 'models/enums.dart';
import 'services/character_service.dart';
import 'services/magic_item_service.dart';

class RPGCLI {
  final CharacterService characterService = CharacterService();
  final MagicItemService magicItemService = MagicItemService();

  void run() {
    while (true) {
      print('\n=== RPG Management System ===');
      print('1. Gerenciar Personagens');
      print('2. Gerenciar Itens Mágicos');
      print('3. Sair');
      print('Escolha uma opção: ');

      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          manageCharacters();
          break;
        case '2':
          manageMagicItems();
          break;
        case '3':
          print('Saindo do sistema...');
          return;
        default:
          print('Opção inválida!');
      }
    }
  }

  void manageCharacters() {
    while (true) {
      print('\n=== Gerenciamento de Personagens ===');
      print('1. Criar Personagem');
      print('2. Listar Personagens');
      print('3. Buscar Personagem por ID');
      print('4. Atualizar Personagem');
      print('5. Remover Personagem');
      print('6. Adicionar Item a Personagem');
      print('7. Remover Item de Personagem');
      print('8. Listar Itens de Personagem');
      print('9. Buscar Amuleto de Personagem');
      print('10. Voltar');
      print('Escolha uma opção: ');

      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          createCharacter();
          break;
        case '2':
          listCharacters();
          break;
        case '3':
          getCharacterById();
          break;
        case '4':
          updateCharacter();
          break;
        case '5':
          deleteCharacter();
          break;
        case '6':
          addItemToCharacter();
          break;
        case '7':
          removeItemFromCharacter();
          break;
        case '8':
          listCharacterItems();
          break;
        case '9':
          getCharacterAmulet();
          break;
        case '10':
          return;
        default:
          print('Opção inválida!');
      }
    }
  }

  void manageMagicItems() {
    while (true) {
      print('\n=== Gerenciamento de Itens Mágicos ===');
      print('1. Criar Item Mágico');
      print('2. Listar Itens Mágicos');
      print('3. Buscar Item por ID');
      print('4. Atualizar Item');
      print('5. Remover Item');
      print('6. Voltar');
      print('Escolha uma opção: ');

      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          createMagicItem();
          break;
        case '2':
          listMagicItems();
          break;
        case '3':
          getMagicItemById();
          break;
        case '4':
          updateMagicItem();
          break;
        case '5':
          deleteMagicItem();
          break;
        case '6':
          return;
        default:
          print('Opção inválida!');
      }
    }
  }

  void createCharacter() {
    try {
      print('\n=== Criar Personagem ===');
      print('ID: ');
      final id = stdin.readLineSync()!;
      print('Nome: ');
      final name = stdin.readLineSync()!;
      print('Nome de Aventureiro: ');
      final adventurerName = stdin.readLineSync()!;

      print('\nClasses disponíveis:');
      CharacterClass.values.forEach((c) => print('${c.index + 1}. ${c.name}'));
      print('Escolha a classe (número): ');
      final classIndex = int.parse(stdin.readLineSync()!) - 1;
      final characterClass = CharacterClass.values[classIndex];

      print('Level: ');
      final level = int.parse(stdin.readLineSync()!);

      print('\nDistribua 10 pontos entre Força e Defesa');
      print('Força: ');
      final force = int.parse(stdin.readLineSync()!);
      print('Defesa: ');
      final defense = int.parse(stdin.readLineSync()!);

      final character = characterService.createCharacter(
        id: id,
        name: name,
        adventurerName: adventurerName,
        characterClass: characterClass,
        level: level,
        baseForce: force,
        baseDefense: defense,
      );

      print('\nPersonagem criado com sucesso!');
      print(character);
    } catch (e) {
      print('Erro ao criar personagem: $e');
    }
  }

  void listCharacters() {
    final characters = characterService.getAllCharacters();
    if (characters.isEmpty) {
      print('Nenhum personagem cadastrado.');
      return;
    }
    print('\n=== Lista de Personagens ===');
    characters.forEach(print);
  }

  void getCharacterById() {
    print('\nID do Personagem: ');
    final id = stdin.readLineSync()!;
    try {
      final character = characterService.getCharacterById(id);
      print('\nPersonagem encontrado:');
      print(character);
    } catch (e) {
      print('Erro: $e');
    }
  }

  void updateCharacter() {
    print('\nID do Personagem: ');
    final id = stdin.readLineSync()!;
    try {
      characterService.getCharacterById(id);

      print('Novo Nome (deixe em branco para manter): ');
      final name = stdin.readLineSync();

      print('Novo Nome de Aventureiro (deixe em branco para manter): ');
      final adventurerName = stdin.readLineSync();

      print('\nClasses disponíveis:');
      CharacterClass.values.forEach((c) => print('${c.index + 1}. ${c.name}'));
      print('Nova Classe (número, deixe em branco para manter): ');
      final classInput = stdin.readLineSync();
      CharacterClass? characterClass;
      if (classInput?.isNotEmpty == true) {
        characterClass = CharacterClass.values[int.parse(classInput!) - 1];
      }

      print('Novo Level (deixe em branco para manter): ');
      final levelInput = stdin.readLineSync();
      int? level;
      if (levelInput?.isNotEmpty == true) {
        level = int.parse(levelInput!);
      }

      print('Nova Força (deixe em branco para manter): ');
      final forceInput = stdin.readLineSync();
      int? force;
      if (forceInput?.isNotEmpty == true) {
        force = int.parse(forceInput!);
      }

      print('Nova Defesa (deixe em branco para manter): ');
      final defenseInput = stdin.readLineSync();
      int? defense;
      if (defenseInput?.isNotEmpty == true) {
        defense = int.parse(defenseInput!);
      }

      final updatedCharacter = characterService.updateCharacter(
        id: id,
        name: name,
        adventurerName: adventurerName,
        characterClass: characterClass,
        level: level,
        baseForce: force,
        baseDefense: defense,
      );

      print('\nPersonagem atualizado com sucesso!');
      print(updatedCharacter);
    } catch (e) {
      print('Erro: $e');
    }
  }

  void deleteCharacter() {
    print('\nID do Personagem: ');
    final id = stdin.readLineSync()!;
    try {
      characterService.deleteCharacter(id);
      print('Personagem removido com sucesso!');
    } catch (e) {
      print('Erro: $e');
    }
  }

  void createMagicItem() {
    try {
      print('\n=== Criar Item Mágico ===');
      print('ID: ');
      final id = stdin.readLineSync()!;
      print('Nome: ');
      final name = stdin.readLineSync()!;

      print('\nTipos disponíveis:');
      ItemType.values.forEach((t) => print('${t.index + 1}. ${t.name}'));
      print('Escolha o tipo (número): ');
      final typeIndex = int.parse(stdin.readLineSync()!) - 1;
      final type = ItemType.values[typeIndex];

      print('Força: ');
      final force = int.parse(stdin.readLineSync()!);
      print('Defesa: ');
      final defense = int.parse(stdin.readLineSync()!);

      final item = magicItemService.createItem(
        id: id,
        name: name,
        type: type,
        force: force,
        defense: defense,
      );

      print('\nItem criado com sucesso!');
      print(item);
    } catch (e) {
      print('Erro ao criar item: $e');
    }
  }

  void listMagicItems() {
    final items = magicItemService.getAllItems();
    if (items.isEmpty) {
      print('Nenhum item cadastrado.');
      return;
    }
    print('\n=== Lista de Itens Mágicos ===');
    items.forEach(print);
  }

  void getMagicItemById() {
    print('\nID do Item: ');
    final id = stdin.readLineSync()!;
    try {
      final item = magicItemService.getItemById(id);
      print('\nItem encontrado:');
      print(item);
    } catch (e) {
      print('Erro: $e');
    }
  }

  void updateMagicItem() {
    print('\nID do Item: ');
    final id = stdin.readLineSync()!;
    try {
      magicItemService.getItemById(id);

      print('Novo Nome (deixe em branco para manter): ');
      final name = stdin.readLineSync();

      print('\nTipos disponíveis:');
      ItemType.values.forEach((t) => print('${t.index + 1}. ${t.name}'));
      print('Novo Tipo (número, deixe em branco para manter): ');
      final typeInput = stdin.readLineSync();
      ItemType? type;
      if (typeInput?.isNotEmpty == true) {
        type = ItemType.values[int.parse(typeInput!) - 1];
      }

      print('Nova Força (deixe em branco para manter): ');
      final forceInput = stdin.readLineSync();
      int? force;
      if (forceInput?.isNotEmpty == true) {
        force = int.parse(forceInput!);
      }

      print('Nova Defesa (deixe em branco para manter): ');
      final defenseInput = stdin.readLineSync();
      int? defense;
      if (defenseInput?.isNotEmpty == true) {
        defense = int.parse(defenseInput!);
      }

      final updatedItem = magicItemService.updateItem(
        id: id,
        name: name,
        type: type,
        force: force,
        defense: defense,
      );

      print('\nItem atualizado com sucesso!');
      print(updatedItem);
    } catch (e) {
      print('Erro: $e');
    }
  }

  void deleteMagicItem() {
    print('\nID do Item: ');
    final id = stdin.readLineSync()!;
    try {
      magicItemService.deleteItem(id);
      print('Item removido com sucesso!');
    } catch (e) {
      print('Erro: $e');
    }
  }

  void addItemToCharacter() {
    print('\nID do Personagem: ');
    final characterId = stdin.readLineSync()!;
    print('ID do Item: ');
    final itemId = stdin.readLineSync()!;

    try {
      final item = magicItemService.getItemById(itemId);
      characterService.addItemToCharacter(characterId, item);
      print('Item adicionado ao personagem com sucesso!');
    } catch (e) {
      print('Erro: $e');
    }
  }

  void removeItemFromCharacter() {
    print('\nID do Personagem: ');
    final characterId = stdin.readLineSync()!;
    print('ID do Item: ');
    final itemId = stdin.readLineSync()!;

    try {
      characterService.removeItemFromCharacter(characterId, itemId);
      print('Item removido do personagem com sucesso!');
    } catch (e) {
      print('Erro: $e');
    }
  }

  void listCharacterItems() {
    print('\nID do Personagem: ');
    final characterId = stdin.readLineSync()!;
    try {
      final items = characterService.getCharacterItems(characterId);
      if (items.isEmpty) {
        print('Personagem não possui itens.');
        return;
      }
      print('\n=== Itens do Personagem ===');
      items.forEach(print);
    } catch (e) {
      print('Erro: $e');
    }
  }

  void getCharacterAmulet() {
    print('\nID do Personagem: ');
    final characterId = stdin.readLineSync()!;
    try {
      final amulet = characterService.getCharacterAmulet(characterId);
      if (amulet == null) {
        print('Personagem não possui amuleto.');
        return;
      }
      print('\nAmuleto do Personagem:');
      print(amulet);
    } catch (e) {
      print('Erro: $e');
    }
  }
}

void main() {
  final cli = RPGCLI();
  cli.run();
}