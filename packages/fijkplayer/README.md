# Local fijkplayer compatibility patch

This directory contains the runtime sources of
[`befovy/fijkplayer`](https://github.com/befovy/fijkplayer), version 0.11.0,
distributed under the included MIT license.

The app uses this local copy because the published Android plugin is incompatible
with the current Flutter and Android Gradle Plugin versions. Android changes:

- Declare `com.befovy.fijkplayer` as the Gradle namespace and remove the legacy
  manifest package attribute.
- Compile against Android SDK 36, matching the app's Flutter SDK.
- Remove the deleted Flutter v1 `PluginRegistry.Registrar` integration. Plugin
  registration uses the existing `FlutterPlugin` and `ActivityAware` interfaces.

The Dart API, iOS implementation, and ijkplayer native dependency are retained
from version 0.11.0.
