# Brief: upgrade a Flutter 3.47 / Dart 3

Rama: `chore/upgrade-flutter` · Fecha: 2026-10-21

## Objetivo

Sacar el proyecto del stack de 2020 (Dart <3.0, sin null safety, Gradle 4.10, AGP 3.2.1, embedding v1) a uno actual y compilable.

## Estado

| Parte | Estado |
|-------|--------|
| Dart (`lib/`) | `flutter analyze` sin errores; 19 avisos menores |
| Android | Migrado, **sin compilar** (no hay Android SDK en la máquina del upgrade) |
| iOS | Migrado, **sin compilar** (no hay Xcode ni CocoaPods) |
| Pruebas manuales | Pendientes |

## Cambios en Dart

- SDK `>=3.0.0 <4.0.0`; todas las dependencias a última versión; se agrega `collection`.
- Null safety: campos de modelos nullable, `late` en estado de formularios, `!` donde antes se asumía no-nulo (mismo comportamiento ante null: crash).
- `gradient_app_bar` (abandonado) reemplazado por `lib/ui/global/gradient_app_bar.dart`, misma API.
- `NavigationDrawer` renombrado a `AppNavigationDrawer` (chocaba con Flutter).
- Botones: `RaisedButton` → `ElevatedButton`, `FlatButton` → `TextButton`.
- `flutter_slidable`: `actionPane`/`secondaryActions` → `endActionPane` + `SlidableAction`.
- `image_picker`: `ImagePicker().pickImage` devuelve `XFile`; se convierte a `File`.
- `url_launcher`: `canLaunch`/`launch` → `canLaunchUrl`/`launchUrl`.
- `http`: URLs con `Uri.parse`.
- Tema: `accentColor` → `colorScheme.secondary`; `AppBarTheme.textTheme` → `titleTextStyle`.
- Formularios: `autovalidate` → `autovalidateMode`; `WhitelistingTextInputFormatter` → `FilteringTextInputFormatter`; validadores `String? Function(String?)`.
- Toast: `timeInSecForIos` → `timeInSecForIosWeb`.
- Rutas sin uso eliminadas de `main.dart`: `/scpl/aval_client`, `/friend_citizen_details`, `/voter_citizen_details` (se navega con `MaterialPageRoute`).

## Cambios en Android

- Build files Groovy → Kotlin DSL (`build.gradle.kts`, `settings.gradle.kts`); Gradle 9.3.1.
- Embedding v2: `MainActivity` usa `FlutterActivity` de `io.flutter.embedding`; se elimina `GeneratedPluginRegistrant` manual.
- `namespace` = `np.com.sahsantosh.voting_app`; `applicationId` se mantiene `ar.com.geapp.app`.
- Firmado release vía `android/key.properties` (sin cambios de comportamiento).
- Manifest: `exported`, `NormalTheme`, `flutterEmbedding=2`, `queries` para `https` y `whatsapp`.
- `values-night/styles.xml` agregado.

## Cambios en iOS

- `Podfile` reescrito con `podhelper` actual; `platform :ios, '13.0'`.
- `IPHONEOS_DEPLOYMENT_TARGET` y `MinimumOSVersion` en 13.0.
- `#include?` para los xcconfig de Pods.
- Eliminados `Podfile.lock` y `Flutter/Flutter.podspec`.
- **No** se adoptó la plantilla nueva (SceneDelegate, Swift Package Manager): requiere editar `project.pbxproj` y validar en Xcode.

## Pendiente (hacer en máquina con SDKs)

1. `flutter build apk --debug` y corregir lo que falle (versión de Gradle/AGP/Kotlin, plugins).
2. `cd ios && pod install`, luego `flutter build ios`; commitear el nuevo `Podfile.lock`.
3. Probar a mano: login, registro, recuperar contraseña, lista de amigos (deslizar para eliminar), mesa de votación, escrutinio con foto de cámara/galería, aval SCPL, abrir WhatsApp y términos.
4. Revisar `LSApplicationQueriesSchemes` en `Info.plist` (WhatsApp) y permisos de cámara/fotos.
5. Reemplazar `test/widget_test.dart` (template del contador, ya fallaba).
6. Revisar los 19 avisos de `flutter analyze`.

## Riesgos

- Los `!` agregados son mecánicos: un dato nulo del backend sigue crasheando; conviene endurecer los modelos más adelante.
- Los line endings de los archivos tocados se restauraron a CRLF para minimizar el diff.
- Flutter marca como deprecado el soporte de builds en Macs Intel.

## Seguridad

`android/key.properties` (contraseñas y alias del keystore) está versionado en git. Sacarlo del repo (`git rm --cached`, agregarlo a `.gitignore`) y rotar las claves.
