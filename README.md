# MVVM Elementary — Flutter ToDo App

Учебный проект, демонстрирующий **Clean Architecture** и **MVVM** с использованием пакета [Elementary](https://pub.dev/packages/elementary).

---

## Архитектура

```
lib/
├── core/
│   └── app_dependencies.dart        # DI (Provider)
│
├── data/                            # Data Layer
│   ├── models/
│   │   └── task_model.dart          # DTO / mapper
│   └── repositories/
│       └── task_repository.dart     # Реализация репозитория
│
├── domain/                          # Domain Layer
│   ├── entities/
│   │   └── task.dart                # Бизнес-сущность
│   ├── repositories/
│   │   └── i_task_repository.dart   # Абстрактный репозиторий
│   └── usecases/
│       ├── get_tasks_usecase.dart
│       ├── add_task_usecase.dart
│       ├── toggle_task_usecase.dart
│       └── delete_task_usecase.dart
│
└── presentation/                    # Presentation Layer (MVVM via Elementary)
    └── home/
        ├── home_model.dart          # M — ElementaryModel (бизнес-вызовы)
        ├── home_widget_model.dart   # VM — WidgetModel (UI-состояние)
        └── home_widget.dart         # V — ElementaryWidget (чистый UI)
```

---

## MVVM с Elementary

| Роль | Класс | Ответственность |
|------|-------|-----------------|
| **Model** | `HomeModel extends ElementaryModel` | Вызывает use-case'ы, не знает о UI |
| **ViewModel** | `HomeWidgetModel extends WidgetModel` | Хранит `EntityStateNotifier`, координирует вызовы |
| **View** | `HomeWidget extends ElementaryWidget` | Только рендеринг; читает состояния через `EntityStateNotifierBuilder` |

---

## Запуск

```bash
flutter pub get
flutter run
```

## Тесты

```bash
flutter test
```

---

## Стек

| Пакет | Версия | Назначение |
|-------|--------|-----------|
| `elementary` | ^3.2.1 | MVVM-фреймворк |
| `elementary_helper` | ^1.2.0 | EntityStateNotifier, StateNotifier, builders |
| `elementary_test` | ^3.0.0 | Тестирование WidgetModel |
| `provider` | ^6.1.2 | DI-контейнер |
| `uuid` | ^4.4.0 | Генерация ID |
| `equatable` | ^2.0.5 | Value-equality для сущностей |
| `mocktail` | ^1.0.4 | Моки в тестах |
