# ⏱️ Marcador de Horas com Flutter + Firebase
App móvel para registrar horas trabalhadas, com autenticação (e-mail/senha e Google), temas claro/escuro, e suporte a três idiomas (pt-BR, en-US, es-ES).

---

## 🚀 Visão Geral
O **Horas v3** permite cadastrar, editar e excluir registros de horas, ver o total consolidado, e gerenciar conta e preferências do usuário.  
O projeto foi modernizado para **Material 3**, recebeu **i18n (pt/en/es)** via **gen_l10n**, e persistência de tema/idioma.

---

## ✨ Destaques do Último Commit
- 🌍 **i18n completo (pt, en, es)**: login, cadastro, menu, home e modal de recuperar senha.
- 🔤 **Arquivos .arb corrigidos** (JSON válido) e **chaves padronizadas**.
- 🎨 **Tema Material 3** com **TextTheme** atualizado (titleLarge, bodyLarge, bodyMedium) e persistência via **SharedPreferences**.
- 🌓 **Toggle de tema no menu** (claro/escuro) com **salvamento automático**.
- 🌐 **Seletor de idioma no menu** (persistido): Português, Inglês e Espanhol.
- 🧭 **Cadastro com botão Cancelar** e **labels localizadas**.
- 🔑 **Login com e-mail/senha** e **Google Sign-In**.
- 📨 **Reset de senha** com **modal localizado** e **mensagem com e-mail dinâmico**.
- 🔔 **FCM configurado** (escuta em foreground e handler background).
- 🕒 **ClockWidget** no **AppBar**.
- 🗓️ **Máscaras de entrada** (data e horas) e **cálculo de total** com formatação.

---

## 🧩 Funcionalidades
- **Registros de horas (CRUD)**  
  - Adição/edição com máscara (dd/MM/yyyy e HH:mm)  
  - Exclusão com swipe (Dismissible)  
  - Total somado e exibido no AppBar  
- **Autenticação**  
  - E-mail/Senha (Firebase Auth)  
  - Google Sign-In  
  - Redefinição de senha por e-mail  
  - Exclusão de conta com confirmação de senha (reautenticação)  
- **Preferências**  
  - Tema claro/escuro (persistente)  
  - Idioma (pt/en/es) persistente  
- **Notificações**  
  - Firebase Cloud Messaging (token e listeners)

---

## 🛠️ Stack & Dependências Principais
- **Flutter** (Material 3), Dart  
- **Firebase**: firebase_core, firebase_auth, cloud_firestore, firebase_messaging  
- **Login Google**: google_sign_in  
- **Estado**: provider  
- **Localização**: flutter_localizations, intl (+ gen_l10n), .arb (pt/en/es)  
- **Utilitários**: shared_preferences, mask_text_input_formatter, uuid, logger

---

## 🗂️ Estrutura do Projeto (resumo)
```bash
lib/
├─ components/
│  └─ menu.dart                      # Drawer (excluir conta, reset senha, tema, idioma, sair)
├─ helpers/
│  └─ hour_helpers.dart              # Conversões HH:mm <-> minutos
├─ l10n/
│  ├─ app_localizations.dart         # Delegate + lookup (pt/en/es)
│  ├─ app_localizations_pt.dart      # Strings pt (classe)
│  ├─ app_localizations_en.dart      # Strings en (classe)
│  ├─ app_localizations_es.dart      # Strings es (classe)
│  ├─ app_pt.arb                     # Chaves pt (JSON)
│  ├─ app_en.arb                     # Chaves en (JSON)
│  └─ app_es.arb                     # Chaves es (JSON)
├─ models/
│  ├─ hour.dart                      # Modelo Hour
│  ├─ language_provider.dart         # Locale + persistência
│  └─ theme_provider.dart            # Tema M3 + persistência
├─ screens/
│  ├─ home_screen.dart               # Lista de horas, total, FAB + modal
│  ├─ login_screen.dart              # Login (e-mail/senha, Google, links)
│  ├─ register_screen.dart           # Cadastro + Cancelar
│  └─ reset_password_modal.dart      # Modal de reset de senha
├─ services/
│  └─ auth_service.dart              # Fluxos de auth (entrar, cadastrar, reset, excluir conta)
├─ firebase_options.dart             # Gerado por flutterfire configure
└─ main.dart                         # Providers, MaterialApp, roteamento/auth stream
```
---

🧪 i18n (gen_l10n)
------------------

**supportedLocales**: Locale('pt', 'BR'), Locale('en', 'US'), Locale('es', 'ES')

**.arb** são JSON puro. Exemplo app_es.arb:

```json
{
  "@@locale": "es",
  "changeLanguageButton": "Cambiar Idioma",
  "horas": "Horas",
  "deleteAccount": "Eliminar Cuenta",
  "resetPassword": "Recuperar contraseña",
  "changeTheme": "Cambiar Tema",
  "logOut": "Cerrar Sesión",
  "confirmDeleteAccount": "Confirmar Eliminación",
  "passwordPrompt": "Introduce tu contraseña para confirmar la eliminación de la cuenta:",
  "cancel": "Cancelar",
  "confirm": "Confirmar"
}
```

---

## ⚙️ Configuração & Execução

### Pré-requisitos

-   Flutter SDK

-   Projeto Firebase (Android/iOS/Web) integrado

-   Para Google Sign-In: SHA-1 (Android) e OAuth Client (Web/iOS)

### Passo a passo

1.  **Clonar o repositório:**

    `git clone <URL_DO_REPO>
    cd <PASTA>`

2.  **Configurar Firebase (gera firebase_options.dart):**

    `flutterfire configure`

3.  **Habilitar provedores no Firebase Console:**

    -   Email/Password

    -   Google

4.  **Instalar dependências:**

    `flutter pub get`

5.  **(opcional) Gerar localizações:**

    `flutter gen-l10n`

6.  **Rodar o aplicativo:**

    - flutter run
    
    **ou selecionar:**
    
    - flutter run -d chrome
    - flutter run -d emulator-5554


---

## 🧯 Troubleshooting (erros comuns)

### ARB inválido:

FormatException: Unexpected character\
Os arquivos .arb devem ser JSON puro (sem imports/classe). Use apenas chaves/valores.

### TextTheme (M3) --- parâmetros não encontrados:

No named parameter 'headline6' / 'bodyText1' / 'bodyText2'\
Em Material 3, use titleLarge, bodyLarge, bodyMedium etc.

### Google Sign-In Android:

Garanta SHA-1 cadastrado no Firebase e google-services.json atualizado.

### Idioma não muda:

Verifique supportedLocales, .arb presentes e LanguageProvider aplicando locale no MaterialApp.

---

## 🧱 Decisões de Arquitetura

-   **Provider** para tema e idioma (simples e enxuto).

-   **Services** isolam Firebase Auth.

-   **Helpers** para lógica de tempo (conversões).

-   **L10n** centralizado com gen_l10n + .arb por idioma.

-   **Firestore** por usuário (coleção = uid).

---

## 🔮 Roadmap (sugestões)

-   📊 **Exportar registros** (CSV/Excel/PDF).

-   🔎 **Busca e filtros** por data/período.

-   ☁️ **Sincronização/Cache offline** (Cloud Firestore + get()/snapshots() reativos).

-   🧪 **Testes unitários/widget** (HourHelper, widgets principais).

-   🎨 **Paletas personalizáveis no app** (temas salvos).

---

## ▶️ Scripts úteis

-   **Limpar e reconstruir:**

    `flutter clean && flutter pub get`

-   **Rodar em Chrome:**

    `flutter run -d chrome`

-   **Gerar l10n:**

    `flutter gen-l10n`

---

## 👨‍💻 Autor

<p align="center"> Desenvolvido com 💙 por <strong>Cleiton Queiroz</strong> </p> <p align="center"> <a href="https://www.linkedin.com/in/cleitonqueiroz-dev" target="_blank"> <img src="https://img.shields.io/badge/-LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"> </a> <a href="https://github.com/CleitonQ" target="_blank"> <img src="https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"> </a> <a href="https://wa.me/5515996295847" target="_blank"> <img src="https://img.shields.io/badge/-WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" alt="WhatsApp"> </a> </p>
