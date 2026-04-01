# Установка иконки приложения

## Файл иконки
`app_icon.png` - логотип МГУ им. Огарёва

## Шаг 1: Установите flutter_launcher_icons

Добавьте в `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "app_icon.png"
```

## Шаг 2: Запустите генератор

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

Это автоматически создаст все нужные размеры иконок для Android и iOS.

## Готово!

Иконка установлена. При следующей сборке (`flutter run`) приложение будет с новой иконкой.

---

**Примечание:** Если не хотите добавлять зависимость, можно вручную:
1. Открыть `android/app/src/main/res/`
2. Заменить файлы в папках `mipmap-*/ic_launcher.png`

Но автоматический способ через flutter_launcher_icons намного проще!
