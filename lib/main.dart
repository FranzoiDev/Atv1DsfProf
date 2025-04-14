import 'models/enums.dart';
import 'services/character_service.dart';
import 'services/magic_item_service.dart';
import 'utils/ui_utils.dart';

class RPGCLI {
  final CharacterService characterService = CharacterService();
  final MagicItemService magicItemService = MagicItemService();

  void run() {
    while (true) {
      UIUtils.clearScreen();
      UIUtils.printHeader('Sistema de Gerenciamento RPG');
      UIUtils.printMenu([
        'Gerenciar Personagens',
        'Gerenciar Itens Mágicos',
        'Sair'
      ]);

      final choice = UIUtils.getNumericInput('Escolha uma opção', min: 1, max: 3);

      switch (choice) {
        case 1:
          manageCharacters();
          break;
        case 2:
          manageMagicItems();
          break;
        case 3:
          UIUtils.printSuccess('Saindo do sistema...');
          return;
        default:
          UIUtils.printError('Opção inválida!');
      }
    }
  }

  void manageCharacters() {
    while (true) {
      UIUtils.clearScreen();
      UIUtils.printHeader('Gerenciamento de Personagens');
      UIUtils.printMenu([
        'Criar Personagem',
        'Listar Personagens',
        'Buscar Personagem por ID',
        'Atualizar Personagem',
        'Remover Personagem',
        'Adicionar Item a Personagem',
        'Remover Item de Personagem',
        'Listar Itens de Personagem',
        'Buscar Amuleto de Personagem',
        'Voltar'
      ]);

      final choice = UIUtils.getNumericInput('Escolha uma opção', min: 1, max: 10);

      switch (choice) {
        case 1:
          createCharacter();
          break;
        case 2:
          listCharacters();
          break;
        case 3:
          getCharacterById();
          break;
        case 4:
          updateCharacter();
          break;
        case 5:
          deleteCharacter();
          break;
        case 6:
          addItemToCharacter();
          break;
        case 7:
          removeItemFromCharacter();
          break;
        case 8:
          listCharacterItems();
          break;
        case 9:
          getCharacterAmulet();
          break;
        case 10:
          return;
        default:
          UIUtils.printError('Opção inválida!');
      }
    }
  }

  void manageMagicItems() {
    while (true) {
      UIUtils.clearScreen();
      UIUtils.printHeader('Gerenciamento de Itens Mágicos');
      UIUtils.printMenu([
        'Criar Item Mágico',
        'Listar Itens Mágicos',
        'Buscar Item por ID',
        'Atualizar Item',
        'Remover Item',
        'Voltar'
      ]);

      final choice = UIUtils.getNumericInput('Escolha uma opção', min: 1, max: 6);

      switch (choice) {
        case 1:
          createMagicItem();
          break;
        case 2:
          listMagicItems();
          break;
        case 3:
          getMagicItemById();
          break;
        case 4:
          updateMagicItem();
          break;
        case 5:
          deleteMagicItem();
          break;
        case 6:
          return;
        default:
          UIUtils.printError('Opção inválida!');
      }
    }
  }

  void createCharacter() {
    try {
      UIUtils.clearScreen();
      UIUtils.printHeader('Criar Personagem');

      final id = UIUtils.getInput('ID', required: true)!;
      final name = UIUtils.getInput('Nome', required: true)!;
      final adventurerName = UIUtils.getInput('Nome de Aventureiro', required: true)!;

      UIUtils.printInfo('\nClasses disponíveis:');
      CharacterClass.values.forEach((c) => UIUtils.printInfo('${c.index + 1}. ${c.name}'));
      final classIndex = UIUtils.getNumericInput('Escolha a classe', min: 1, max: CharacterClass.values.length)! - 1;
      final characterClass = CharacterClass.values[classIndex];

      final level = UIUtils.getNumericInput('Level', min: 1)!;

      UIUtils.printInfo('\nDistribua 10 pontos entre Força e Defesa');
      final force = UIUtils.getNumericInput('Força', min: 0, max: 10)!;
      final defense = UIUtils.getNumericInput('Defesa', min: 0, max: 10 - force)!;

      UIUtils.showLoading('Criando personagem...');
      final character = characterService.createCharacter(
        id: id,
        name: name,
        adventurerName: adventurerName,
        characterClass: characterClass,
        level: level,
        baseForce: force,
        baseDefense: defense,
      );
      UIUtils.stopLoading();

      UIUtils.printSuccess('\nPersonagem criado com sucesso!');
      print(character);
    } catch (e) {
      UIUtils.printError('Erro ao criar personagem: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void listCharacters() {
    final characters = characterService.getAllCharacters();
    if (characters.isEmpty) {
      UIUtils.printWarning('Nenhum personagem cadastrado.');
      return;
    }

    UIUtils.clearScreen();
    UIUtils.printHeader('Lista de Personagens');

    final headers = ['ID', 'Nome', 'Classe', 'Nível', 'Força', 'Defesa'];
    final rows = characters.map((c) => [
      c.id,
      c.name,
      c.characterClass.name,
      c.level.toString(),
      c.totalForce.toString(),
      c.totalDefense.toString()
    ]).toList();

    UIUtils.printTable(headers, rows);
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void getCharacterById() {
    final id = UIUtils.getInput('ID do Personagem', required: true)!;
    try {
      UIUtils.showLoading('Buscando personagem...');
      final character = characterService.getCharacterById(id);
      UIUtils.stopLoading();

      UIUtils.clearScreen();
      UIUtils.printHeader('Detalhes do Personagem');
      print(character);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void updateCharacter() {
    final id = UIUtils.getInput('ID do Personagem', required: true)!;
    try {
      characterService.getCharacterById(id);

      final name = UIUtils.getInput('Novo Nome (deixe em branco para manter)', required: false);
      final adventurerName = UIUtils.getInput('Novo Nome de Aventureiro (deixe em branco para manter)', required: false);

      UIUtils.printInfo('\nClasses disponíveis:');
      CharacterClass.values.forEach((c) => UIUtils.printInfo('${c.index + 1}. ${c.name}'));
      final classInput = UIUtils.getNumericInput('Nova Classe (deixe em branco para manter)', required: false, min: 1, max: CharacterClass.values.length);
      CharacterClass? characterClass;
      if (classInput != null) {
        characterClass = CharacterClass.values[classInput - 1];
      }

      final level = UIUtils.getNumericInput('Novo Level (deixe em branco para manter)', required: false, min: 1);
      final force = UIUtils.getNumericInput('Nova Força (deixe em branco para manter)', required: false, min: 0, max: 10);
      final defense = UIUtils.getNumericInput('Nova Defesa (deixe em branco para manter)', required: false, min: 0, max: 10);

      UIUtils.showLoading('Atualizando personagem...');
      final updatedCharacter = characterService.updateCharacter(
        id: id,
        name: name,
        adventurerName: adventurerName,
        characterClass: characterClass,
        level: level,
        baseForce: force,
        baseDefense: defense,
      );
      UIUtils.stopLoading();

      UIUtils.printSuccess('\nPersonagem atualizado com sucesso!');
      print(updatedCharacter);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void deleteCharacter() {
    final id = UIUtils.getInput('ID do Personagem', required: true)!;
    try {
      UIUtils.showLoading('Removendo personagem...');
      characterService.deleteCharacter(id);
      UIUtils.stopLoading();
      UIUtils.printSuccess('Personagem removido com sucesso!');
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void createMagicItem() {
    try {
      UIUtils.clearScreen();
      UIUtils.printHeader('Criar Item Mágico');

      final id = UIUtils.getInput('ID', required: true)!;
      final name = UIUtils.getInput('Nome', required: true)!;

      UIUtils.printInfo('\nTipos disponíveis:');
      ItemType.values.forEach((t) => UIUtils.printInfo('${t.index + 1}. ${t.name}'));
      final typeIndex = UIUtils.getNumericInput('Escolha o tipo', min: 1, max: ItemType.values.length)! - 1;
      final type = ItemType.values[typeIndex];

      final force = UIUtils.getNumericInput('Força', min: 0, max: 10)!;
      final defense = UIUtils.getNumericInput('Defesa', min: 0, max: 10)!;

      UIUtils.showLoading('Criando item...');
      final item = magicItemService.createItem(
        id: id,
        name: name,
        type: type,
        force: force,
        defense: defense,
      );
      UIUtils.stopLoading();

      UIUtils.printSuccess('\nItem criado com sucesso!');
      print(item);
    } catch (e) {
      UIUtils.printError('Erro ao criar item: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void listMagicItems() {
    final items = magicItemService.getAllItems();
    if (items.isEmpty) {
      UIUtils.printWarning('Nenhum item cadastrado.');
      return;
    }

    UIUtils.clearScreen();
    UIUtils.printHeader('Lista de Itens Mágicos');

    final headers = ['ID', 'Nome', 'Tipo', 'Força', 'Defesa'];
    final rows = items.map((i) => [
      i.id,
      i.name,
      i.type.name,
      i.force.toString(),
      i.defense.toString()
    ]).toList();

    UIUtils.printTable(headers, rows);
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void getMagicItemById() {
    final id = UIUtils.getInput('ID do Item', required: true)!;
    try {
      UIUtils.showLoading('Buscando item...');
      final item = magicItemService.getItemById(id);
      UIUtils.stopLoading();

      UIUtils.clearScreen();
      UIUtils.printHeader('Detalhes do Item');
      print(item);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void updateMagicItem() {
    final id = UIUtils.getInput('ID do Item', required: true)!;
    try {
      magicItemService.getItemById(id);

      final name = UIUtils.getInput('Novo Nome (deixe em branco para manter)', required: false);

      UIUtils.printInfo('\nTipos disponíveis:');
      ItemType.values.forEach((t) => UIUtils.printInfo('${t.index + 1}. ${t.name}'));
      final typeInput = UIUtils.getNumericInput('Novo Tipo (deixe em branco para manter)', required: false, min: 1, max: ItemType.values.length);
      ItemType? type;
      if (typeInput != null) {
        type = ItemType.values[typeInput - 1];
      }

      final force = UIUtils.getNumericInput('Nova Força (deixe em branco para manter)', required: false, min: 0, max: 10);
      final defense = UIUtils.getNumericInput('Nova Defesa (deixe em branco para manter)', required: false, min: 0, max: 10);

      UIUtils.showLoading('Atualizando item...');
      final updatedItem = magicItemService.updateItem(
        id: id,
        name: name,
        type: type,
        force: force,
        defense: defense,
      );
      UIUtils.stopLoading();

      UIUtils.printSuccess('\nItem atualizado com sucesso!');
      print(updatedItem);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void deleteMagicItem() {
    final id = UIUtils.getInput('ID do Item', required: true)!;
    try {
      UIUtils.showLoading('Removendo item...');
      magicItemService.deleteItem(id);
      UIUtils.stopLoading();
      UIUtils.printSuccess('Item removido com sucesso!');
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void addItemToCharacter() {
    final characterId = UIUtils.getInput('ID do Personagem', required: true)!;
    final itemId = UIUtils.getInput('ID do Item', required: true)!;

    try {
      UIUtils.showLoading('Adicionando item ao personagem...');
      final item = magicItemService.getItemById(itemId);
      characterService.addItemToCharacter(characterId, item);
      UIUtils.stopLoading();
      UIUtils.printSuccess('Item adicionado ao personagem com sucesso!');
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void removeItemFromCharacter() {
    final characterId = UIUtils.getInput('ID do Personagem', required: true)!;
    final itemId = UIUtils.getInput('ID do Item', required: true)!;

    try {
      UIUtils.showLoading('Removendo item do personagem...');
      characterService.removeItemFromCharacter(characterId, itemId);
      UIUtils.stopLoading();
      UIUtils.printSuccess('Item removido do personagem com sucesso!');
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void listCharacterItems() {
    final characterId = UIUtils.getInput('ID do Personagem', required: true)!;
    try {
      UIUtils.showLoading('Buscando itens do personagem...');
      final items = characterService.getCharacterItems(characterId);
      UIUtils.stopLoading();

      if (items.isEmpty) {
        UIUtils.printWarning('Personagem não possui itens.');
        return;
      }

      UIUtils.clearScreen();
      UIUtils.printHeader('Itens do Personagem');

      final headers = ['ID', 'Nome', 'Tipo', 'Força', 'Defesa'];
      final rows = items.map((i) => [
        i.id,
        i.name,
        i.type.name,
        i.force.toString(),
        i.defense.toString()
      ]).toList();

      UIUtils.printTable(headers, rows);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }

  void getCharacterAmulet() {
    final characterId = UIUtils.getInput('ID do Personagem', required: true)!;
    try {
      UIUtils.showLoading('Buscando amuleto do personagem...');
      final amulet = characterService.getCharacterAmulet(characterId);
      UIUtils.stopLoading();

      if (amulet == null) {
        UIUtils.printWarning('Personagem não possui amuleto.');
        return;
      }

      UIUtils.clearScreen();
      UIUtils.printHeader('Amuleto do Personagem');
      print(amulet);
    } catch (e) {
      UIUtils.printError('Erro: $e');
    }
    UIUtils.getInput('\nPressione Enter para continuar...', required: false);
  }
}

void main() {
  final cli = RPGCLI();
  cli.run();
}