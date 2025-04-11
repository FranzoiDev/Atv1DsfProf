# Atv1DsfProf
[ESOFT] CRUD - Avaliação

# RPG Management System

## Estrutura do Projeto

rpg_management/
├── lib/
│   ├── models/
│   │   ├── character.dart          # Modelo da entidade Personagem
│   │   └── magic_item.dart         # Modelo da entidade Item Mágico
│   ├── services/
│   │   ├── character_service.dart  # Lógica de negócios para Personagem
│   │   └── magic_item_service.dart # Lógica de negócios para Item Mágico
│   ├── main.dart                   # Ponto de entrada da aplicação
├── test/
│   ├── character_test.dart         # Testes para Personagem
│   └── magic_item_test.dart        # Testes para Item Mágico
├── README.md                       # Documentação do projeto
└── pubspec.yaml                    # Dependências e configuração do projeto


## Descrição

O sistema permite o gerenciamento de personagens (com atributos como força, defesa, classe e itens) e itens mágicos (com tipos arma, armadura e amuleto). Cada personagem pode ter múltiplos itens, mas apenas um amuleto. Os atributos de força e defesa dos personagens são somados aos dos itens para exibição.

## Funcionalidades

- **Personagem**:
  - Cadastrar personagem
  - Listar personagens
  - Buscar personagem por ID
  - Atualizar nome aventureiro por ID
  - Remover personagem
- **Item Mágico**:
  - Cadastrar item mágico
  - Listar itens mágicos
  - Buscar item mágico por ID
  - Adicionar item mágico a um personagem
  - Listar itens mágicos por personagem
  - Remover item mágico de um personagem
  - Buscar amuleto de um personagem

## Regras de Negócio

- **Personagem**:
  - Máximo de 10 pontos para distribuir entre força e defesa na criação.
  - Classes disponíveis: Guerreiro, Mago, Arqueiro, Ladino, Bardo.
  - Apenas um item mágico do tipo amuleto por personagem.
  - Força e defesa exibidas incluem os valores dos itens mágicos.
- **Item Mágico**:
  - Tipos: Arma, Armadura, Amuleto.
  - Arma: defesa = 0.
  - Armadura: força = 0.
  - Amuleto: pode ter força e defesa (máximo 10 cada).
  - Não pode ter força e defesa zerados simultaneamente.

## Como Executar

1. Instale o Dart SDK.
2. Clone o repositório.
3. Navegue até a pasta do projeto e execute:
   ```bash
   dart pub get
   dart run lib/main.dart
