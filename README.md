# GeApp (voting_app)

App móvil Flutter (Android e iOS) para gestión de mesas de votación: login y registro, lista de amigos, mesa de votación, escrutinio con carga de acta (foto) y consulta/aval de clientes SCPL.

## Stack

| Área               | Tecnología                                                          |
| ------------------ | ------------------------------------------------------------------- |
| Framework          | Flutter 3.47 / Dart 3 (null safety)                                 |
| Estado             | `scoped_model`                                                      |
| HTTP               | `http`                                                              |
| Persistencia local | `shared_preferences`                                                |
| UI                 | `flutter_slidable`, `fluttertoast`, `cupertino_icons`, fuente Dosis |
| Dispositivo        | `image_picker`, `path_provider`, `url_launcher`, `mime`, `intl`     |
| Android            | Gradle 9.3, AGP 9.1, Kotlin DSL, embedding v2, JDK 17               |
| iOS                | CocoaPods, deployment target 13.0                                   |

## Estructura

```
lib/
  main.dart      # entrada, tema y rutas
  model/         # modelos y (de)serialización JSON
  services/      # mixins de MainModel: llamadas HTTP y estado
  ui/            # pantallas y widgets (ui/global: utils y widgets comunes)
```

## Requisitos

- Flutter stable (`brew install --cask flutter`) y `flutter doctor` sin errores
- Android: Android SDK y JDK 17
- iOS: Xcode completo y CocoaPods

## Correr

```bash
flutter pub get
flutter run
```

## Build

```bash
# Android (requiere android/key.properties con el keystore de release)
flutter build appbundle --release

# iOS
cd ios && pod install && cd ..
flutter build ipa --release
```

La versión se define en `pubspec.yaml` (`version: x.y.z+build`).

## Notas

- Historial y decisiones del último upgrade: [docs/upgrade-flutter-3.md](docs/upgrade-flutter-3.md).
