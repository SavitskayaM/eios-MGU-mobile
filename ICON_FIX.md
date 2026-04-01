# 🔧 Правильная установка иконки

## ❌ Ошибка:
```
Could not find package "flutter_launcher_icons"
```

## ✅ Правильная последовательность:

### Шаг 1: Установите все зависимости
```bash
flutter pub get
```

Вы увидите:
```
Running "flutter pub get" in student_app_final...
+ flutter_launcher_icons 0.13.1
✓ Dependencies installed
```

### Шаг 2: Сгенерируйте иконки
После успешного `flutter pub get` выполните:

```bash
flutter pub run flutter_launcher_icons
```

**ИЛИ** (новый способ):
```bash
dart run flutter_launcher_icons
```

### Шаг 3: Пересоберите приложение
```bash
flutter clean
flutter run
```

---

## 📝 Полная последовательность команд:

```bash
cd ~/Desktop/4курс\ 1сем/2sem/student_app_final
flutter pub get
dart run flutter_launcher_icons
flutter run
```

---

## ✅ После этого:
- Иконка приложения = Логотип МГУ на белом фоне
- Android launcher покажет цветную эмблему

---

## 💡 Почему не работало:

1. **Сначала** нужно установить пакеты (`flutter pub get`)
2. **Потом** запускать инструменты (`dart run flutter_launcher_icons`)

Вы пытались запустить инструмент **ДО** установки!

---

## ⚠️ Если ошибка осталась:

Проверьте что файл `app_icon.png` существует в корне проекта:
```bash
ls app_icon.png
```

Если файла нет - скопируйте логотип:
```bash
cp assets/mrsu_logo.png app_icon.png
```

---

**Попробуйте и напишите результат `flutter pub get`!**
