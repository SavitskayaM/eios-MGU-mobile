# 🔧 Исправление ошибок "package not found"

## ❌ Проблема:
```
Target of URI doesn't exist: 'package:shared_preferences/shared_preferences.dart'
Undefined name 'SharedPreferences'
```

## ✅ Решение:

### Шаг 1: Установите зависимости
Откройте терминал в папке проекта и выполните:

```bash
flutter pub get
```

Эта команда:
- Скачает все пакеты из `pubspec.yaml`
- Установит `shared_preferences`, `http`, `provider` и другие
- Создаст файлы `.dart_tool` и `pubspec.lock`

### Шаг 2: Перезапустите VS Code
После установки зависимостей:
1. Закройте VS Code
2. Откройте снова
3. Или нажмите `Ctrl+Shift+P` → "Dart: Restart Analysis Server"

### Шаг 3: Проверьте pubspec.yaml
Откройте файл `pubspec.yaml` и убедитесь что там есть:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  shared_preferences: ^2.3.2
  http: ^1.2.2
  cached_network_image: ^3.3.1
  table_calendar: ^3.1.2
  intl: ^0.19.0
```

### Шаг 4: Очистка кэша (если не помогло)
Если ошибки остались:

```bash
flutter clean
flutter pub get
```

### Шаг 5: Запуск приложения
```bash
flutter run
```

## 📝 Полная последовательность команд:

```bash
cd C:\Users\Евгеша\Desktop\4курс 1сем\2sem\student_app_final
flutter clean
flutter pub get
flutter run
```

## ✅ После этого:
- ❌ Красные подчеркивания исчезнут
- ✅ VS Code найдет все пакеты
- ✅ Приложение запустится

## 💡 Почему так происходит?
Flutter не скачивает пакеты автоматически. Файл `pubspec.yaml` - это список нужных библиотек, но их нужно **установить** командой `flutter pub get`.

---

**Если проблема осталась - пришлите скриншот ошибки после выполнения `flutter pub get`**
