# ⏱️ Marcador de Horas com Flutter + Firebase
App móvel para registrar horas trabalhadas, com autenticação (e-mail/senha e Google), temas claro/escuro, e suporte a três idiomas (pt-BR, en-US, es).

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

# 🧪 i18n (gen_l10n)

**supportedLocales**: Locale('pt', 'BR'), Locale('en', 'US'), Locale('es')

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

