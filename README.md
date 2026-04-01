# Student App — Финальная версия

Чистое приложение для студентов МГУ им. Огарева на Flutter.

## 🚀 БЫСТРЫЙ СТАРТ

### 1. Распакуйте архив
```bash
cd student_app_final
```

### 2. Создайте платформы (Android, Web и др.)
```bash
flutter create .
```
**Важно!** Эта команда создаст папки `android/`, `web/`, `windows/` и другие нужные файлы для вашей версии Flutter.

### 3. Установите зависимости
```bash
flutter pub get
```

### 4. Запустите на Android
```bash
flutter run -d android
```

### Или на Web
```bash
flutter run -d chrome
```

**Для Web без CORS ограничений:**
```powershell
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --user-data-dir="C:\temp\chrome_dev"
```
Затем: `flutter run -d chrome`

## ✅ Что работает

- ✅ **Android** — полностью рабочее
- ✅ **Web** — работает с ограничениями CORS
- ✅ **Демо режим** — работает без интернета
- ✅ **API режим** — подключение к p.mrsu.ru

## 🚀 Быстрый старт

### ВАЖНО: Используйте `flutter create .` вместо `flutter create --platforms=android .`

Команда `flutter create .` автоматически создаст **все** нужные платформы для вашей версии Flutter.

### Полная инструкция:

```bash
# 1. Перейдите в папку проекта
cd student_app_final

# 2. Создайте платформы (это создаст android/, web/, windows/ и другие)
flutter create .

# 3. Установите зависимости
flutter pub get

# 4. Запустите на Android
flutter run -d android
```

## 🔑 Учётные данные

### Для входа в реальный API:
- **URL:** https://p.mrsu.ru
- **Client ID:** 8
- **Client Secret:** qweasd
- **Логин:** ваш логин от p.mrsu.ru
- **Пароль:** ваш пароль от p.mrsu.ru

### Демо режим:
Приложение работает с демо данными если API недоступен.

## 📁 Структура проекта

```
lib/
├── main.dart                    # Точка входа
├── models/
│   └── student.dart            # Модели данных
├── providers/
│   ├── auth_provider.dart      # Управление авторизацией
│   └── student_provider.dart   # Управление данными студента
├── screens/
│   ├── splash_screen.dart      # Экран загрузки
│   ├── login_screen.dart       # Экран входа
│   └── main_screen.dart        # Главный экран с вкладками
└── services/
    └── api_service.dart        # API клиент
```

## 🔧 Особенности

### Минимальные зависимости
- `http` — сетевые запросы
- `shared_preferences` — хранение данных
- `provider` — управление состоянием
- `intl` — форматирование дат
- `table_calendar` — календарь (не используется в этой версии)

### Без лишних пакетов
- ❌ Нет `dio`
- ❌ Нет `flutter_secure_storage`
- ❌ Нет `json_serializable`
- ❌ Нет `build_runner`

### Работает везде
- ✅ Android
- ✅ Web
- ✅ Windows (с `flutter create --platforms=windows .`)
- ✅ iOS (с `flutter create --platforms=ios .`)

## 📱 Скриншоты экранов

1. **Splash Screen** — загрузка приложения
2. **Login Screen** — вход в систему
3. **Profile Tab** — данные студента
4. **Grades Tab** — оценки и баллы
5. **Timetable Tab** — расписание занятий

## ⚠️ Известные ограничения

### Web + CORS
Браузеры блокируют прямые запросы к `p.mrsu.ru` из-за CORS политики.

**Решения:**
1. Используйте Android
2. Запускайте Chrome с флагом `--disable-web-security`
3. Используйте демо режим

### API credentials
Если `clientId: "8"` и `clientSecret: "qweasd"` не работают:
1. Уточните у администратора p.mrsu.ru
2. Или используйте демо режим

## 🐛 Решение проблем

### Gradle ошибки
```bash
# Создайте Android заново
flutter create --platforms=android .
flutter clean
flutter pub get
flutter run -d android
```

### NDK ошибки
```powershell
# Удалите повреждённый NDK
Remove-Item "$env:USERPROFILE\.gradle\wrapper\dists" -Recurse -Force
```

### Версии несовместимы
```bash
# Пропустить проверку версий
flutter run -d android --android-skip-build-dependency-validation
```

## 📝 Что дальше?

После того как приложение заработает, можно:

1. Подключить реальное API вместо демо данных
2. Добавить pull-to-refresh
3. Добавить кэширование данных
4. Улучшить UI/UX
5. Добавить уведомления

## 💡 Поддержка

Если возникли проблемы:
1. Проверьте версию Flutter: `flutter --version`
2. Очистите проект: `flutter clean`
3. Пересоздайте Android: `flutter create --platforms=android .`
4. Запустите снова

---

**Создано с ❤️ для студентов МГУ им. Огарева**
