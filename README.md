# Pokédex Explorer

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)

**Projeto Somativo da Disciplina: Flutter**  
**Desenvolvimento Mobile Híbrido**

---

## Descrição

O **Pokédex Explorer** é um aplicativo móvel desenvolvido em Flutter que consome a **[PokéAPI](https://pokeapi.co/)** para criar um catálogo interativo de Pokémon. O app permite explorar, buscar e favoritar Pokémon, aplicando conceitos como navegação entre telas, gerenciamento de estado com **Provider** e consumo de APIs de forma assíncrona.

---

## Funcionalidades

- **Lista de Pokémon** em grade, com carregamento incremental.
- **Tela de detalhes** com informações completas de cada Pokémon (imagem, tipos, habilidades e número na Pokédex).
- **Favoritar Pokémon** com estado gerenciado globalmente.
- **Tela de favoritos** atualizada em tempo real.
- **Busca por nome ou número** do Pokémon (opcional).
- **Indicadores de carregamento** e mensagens de erro amigáveis.

---

## Tecnologias Utilizadas

- **Flutter** (Dart)
- **PokéAPI** ([https://pokeapi.co](https://pokeapi.co))
- **Pacotes Flutter:**
  - `http` → requisições à API
  - `provider` → gerenciamento de estado

---

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/luana-akemi-sakurada/Pokedex.git

2. Entre no diretório do projeto:
    ```bash
    cd Pokedex

3. Instale as dependências:
    ```bash
    flutter pub get

4. Execute o app:
    ```bash
    flutter run

---

## Como Usar

1. Explore a lista de Pokémon na tela principal.
2. Toque em um Pokémon para abrir a tela de detalhes.
3. Favorite ou desfavorite usando o ícone de estrela.
4. Acesse a tela de favoritos para visualizar seus Pokémon preferidos.

---

## Contribuição

Este projeto é voltado para fins acadêmicos. Sugestões e feedbacks são bem-vindos!
