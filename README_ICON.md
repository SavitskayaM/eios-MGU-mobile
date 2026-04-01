# 🎓 Установка иконки МГУ в приложение ЭИОС

## ✅ Автоматическая установка (Рекомендуется)

Иконка уже настроена в `pubspec.yaml`! Просто выполните:

```bash
# 1. Установите зависимости
flutter pub get

# 2. Сгенерируйте иконки
flutter pub run flutter_launcher_icons

# 3. Пересоберите приложение
flutter clean
flutter run -d android
```

## 📱 Что произойдёт:

- ✅ Иконка приложения заменится на **цветной логотип МГУ**
- ✅ Фон иконки будет **белым**
- ✅ Логотип будет виден на всех Android лаунчерах

## 🖼️ Файлы иконок:

- `app_icon.png` - Цветной логотип МГУ им. Огарёва
- Автоматически создаются все размеры:
  - `mipmap-mdpi` (48x48)
  - `mipmap-hdpi` (72x72)
  - `mipmap-xhdpi` (96x96)
  - `mipmap-xxhdpi` (144x144)
  - `mipmap-xxxhdpi` (192x192)

## ⚙️ Настройки (уже в pubspec.yaml):

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "app_icon.png"
  adaptive_icon_background: "#FFFFFF"  # Белый фон
  adaptive_icon_foreground: "app_icon.png"  # Цветной логотип
```

## 🔧 Если автоматически не работает:

Вручную скопируйте иконку в:
```
android/app/src/main/res/mipmap-*/ic_launcher.png
```

## ✨ Готово!

После установки иконка вашего приложения будет:
- 🎨 Цветной логотип МГУ
- ⬜ На белом фоне
- 🎓 Профессионально выглядеть на главном экране!
