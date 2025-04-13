import '../models/character.dart';
import '../models/magic_item.dart';
import '../models/enums.dart';

class CharacterService {
  final Map<String, Character> _characters = {};

  Character createCharacter({
    required String id,
    required String name,
    required String adventurerName,
    required CharacterClass characterClass,
    required int level,
    required int baseForce,
    required int baseDefense,
  }) {
    if (_characters.containsKey(id)) {
      throw ArgumentError('Personagem com ID $id já existe');
    }

    final character = Character.create(
      id: id,
      name: name,
      adventurerName: adventurerName,
      characterClass: characterClass,
      level: level,
      baseForce: baseForce,
      baseDefense: baseDefense,
    );

    _characters[id] = character;
    return character;
  }

  List<Character> getAllCharacters() {
    return _characters.values.toList();
  }

  Character getCharacterById(String id) {
    final character = _characters[id];
    if (character == null) {
      throw ArgumentError('Personagem com ID $id não encontrado');
    }
    return character;
  }

  Character updateCharacter({
    required String id,
    String? name,
    String? adventurerName,
    CharacterClass? characterClass,
    int? level,
    int? baseForce,
    int? baseDefense,
  }) {
    final existingCharacter = getCharacterById(id);

    final updatedCharacter = Character.create(
      id: id,
      name: name ?? existingCharacter.name,
      adventurerName: adventurerName ?? existingCharacter.adventurerName,
      characterClass: characterClass ?? existingCharacter.characterClass,
      level: level ?? existingCharacter.level,
      baseForce: baseForce ?? existingCharacter.baseForce,
      baseDefense: baseDefense ?? existingCharacter.baseDefense,
    );

    for (final item in existingCharacter.items) {
      updatedCharacter.addItem(item);
    }

    _characters[id] = updatedCharacter;
    return updatedCharacter;
  }

  void deleteCharacter(String id) {
    if (!_characters.containsKey(id)) {
      throw ArgumentError('Personagem com ID $id não encontrado');
    }
    _characters.remove(id);
  }

  void addItemToCharacter(String characterId, MagicItem item) {
    final character = getCharacterById(characterId);
    character.addItem(item);
  }

  void removeItemFromCharacter(String characterId, String itemId) {
    final character = getCharacterById(characterId);
    character.removeItem(itemId);
  }

  List<MagicItem> getCharacterItems(String characterId) {
    final character = getCharacterById(characterId);
    return character.items;
  }

  MagicItem? getCharacterAmulet(String characterId) {
    final character = getCharacterById(characterId);
    try {
      return character.getAmulet();
    } catch (e) {
      return null;
    }
  }
}