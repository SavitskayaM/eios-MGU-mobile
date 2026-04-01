# Установка иконки приложения МГУ

## Способ 1: Автоматически (Рекомендуется)

1. Добавьте в `pubspec.yaml`:

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

2. Запустите:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

3. Пересоберите приложение:
```bash
flutter clean
flutter run -d android
```

## Способ 2: Вручную

Если автоматический способ не работает:

1. Откройте `android/app/src/main/res/`
2. Замените файлы в папках:
   - `mipmap-mdpi/ic_launcher.png` (48x48)
   - `mipmap-hdpi/ic_launcher.png` (72x72)
   - `mipmap-xhdpi/ic_launcher.png` (96x96)
   - `mipmap-xxhdpi/ic_launcher.png` (144x144)
   - `mipmap-xxxhdpi/ic_launcher.png` (192x192)

3. Используйте `app_icon.png` для создания этих размеров

## Готово!

После установки иконки приложение будет отображаться с логотипом МГУ им. Огарёва! 🎓
