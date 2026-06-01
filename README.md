# ⚽ Copa 2026 App

> Aplicativo mobile desenvolvido com **Flutter** para acompanhamento de partidas da Copa do Mundo FIFA 2026.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?style=flat&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-sqflite-003B57?style=flat&logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/Licença-MIT-green?style=flat)
![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=flat)

---

## 📖 Sobre o Projeto

O **Copa 2026 App** é um aplicativo mobile criado para exibir informações sobre as partidas da Copa do Mundo FIFA 2026. Desenvolvido como projeto acadêmico, o app aplica boas práticas de desenvolvimento Flutter, incluindo componentização de interfaces, organização em camadas, persistência de dados com SQLite e tipografia customizada com Google Fonts.

O projeto foi construído em trio, servindo como prática integradora dos conteúdos de **Análise e Desenvolvimento de Sistemas**, com foco em desenvolvimento mobile e arquitetura de software.

---

## ✨ Funcionalidades

- 📋 Listagem de partidas da Copa do Mundo 2026
- ⚽ Exibição das seleções participantes em cada jogo
- 🕒 Data e horário de cada partida
- 🗄️ Persistência local de dados com SQLite (`sqflite`)
- 🔤 Tipografia customizada via Google Fonts
- 🎨 Interface baseada em Material Design
- 📱 Layout responsivo para diferentes tamanhos de tela
- 🧩 Componentes reutilizáveis (widgets) para exibição dos jogos

---

## 🏗️ Arquitetura do Projeto

```
lib/
│
├── models/
│   └── jogo.dart              # Modelo de dados da partida
│
├── screens/
│   └── tela_lista_jogos.dart  # Tela principal com a listagem
│
├── widgets/
│   └── card_jogo.dart         # Card reutilizável de cada partida
│
└── main.dart                  # Ponto de entrada da aplicação
```

| Camada | Responsabilidade |
|--------|-----------------|
| `models/` | Representação e estrutura dos dados da aplicação |
| `screens/` | Telas e páginas da interface do usuário |
| `widgets/` | Componentes visuais reutilizáveis |
| `main.dart` | Configuração inicial e ponto de entrada |

---

## 🛠️ Tecnologias e Dependências

| Tecnologia | Versão | Uso |
|-----------|--------|-----|
| Flutter | 3.x | Framework principal |
| Dart | ^3.12.0 | Linguagem de programação |
| sqflite | ^2.3.0 | Banco de dados SQLite local |
| sqflite_common_ffi | ^2.3.0 | Suporte desktop para SQLite |
| google_fonts | ^6.1.0 | Fontes customizadas |
| intl | ^0.19.0 | Formatação de datas e internacionalização |
| path | ^1.9.0 | Manipulação de caminhos de arquivo |
| cupertino_icons | ^1.0.8 | Ícones estilo iOS |

---

## 🚀 Como Executar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado e configurado
- Dart SDK ^3.12.0
- Android Studio ou VS Code com extensão Flutter
- Emulador Android/iOS ou dispositivo físico conectado

### Passo a passo

```bash
# 1. Clone o repositório
git clone https://github.com/cindy197/copa_2026_app.git

# 2. Acesse a pasta do projeto
cd copa_2026_app

# 3. Instale as dependências
flutter pub get

# 4. Verifique se o ambiente está configurado
flutter doctor

# 5. Execute o projeto
flutter run
```

### Plataformas suportadas

| Plataforma | Suporte |
|-----------|---------|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| Linux | ✅ |
| macOS | ✅ |
| Windows | ✅ |

---

## 🎯 Objetivos de Aprendizagem

Este projeto foi desenvolvido para consolidar conhecimentos em:

- Desenvolvimento mobile com **Flutter**
- Estruturação de projetos em camadas (Models, Screens, Widgets)
- Criação de **Widgets Stateless e Stateful**
- Componentização e reutilização de interfaces
- Persistência de dados local com **SQLite**
- Formatação de datas com o pacote `intl`
- Tipografia e design com **Google Fonts**
- Organização e boas práticas de código

---

## 📈 Melhorias Futuras

- [ ] Integração com API esportiva em tempo real
- [ ] Tela de detalhes de cada partida
- [ ] Sistema de partidas favoritas
- [ ] Busca e filtragem de jogos
- [ ] Classificação dos grupos
- [ ] Tema escuro (Dark Mode)
- [ ] Notificações de jogos

---

## 👩‍💻 Desenvolvedores

| Nome | GitHub |
|------|--------|
| Cindy Pessoa | [@cindy197](https://github.com/cindy197) |
| Tauan Lima | — |
| Luan Henrique | — |

Estudantes de **Análise e Desenvolvimento de Sistemas**, com foco em Desenvolvimento Mobile e Segurança da Informação.

---

## 📄 Licença

Este projeto é de uso **acadêmico**, desenvolvido como atividade prática de estudo e aprimoramento de habilidades em Flutter e desenvolvimento mobile.

---

<p align="center">
  Feito com ❤️ e ⚽ por Cindy, Tauan e Luan
</p>
