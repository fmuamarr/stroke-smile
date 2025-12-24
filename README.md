# POHPS (Panduan Oral Hygiene Pasien Stroke)

Panduan praktis merawat kebersihan mulut pasien stroke di rumah.

## Features

- **Panduan Step-by-Step**: Detailed instructions for oral care.
- **Mode Cepat (Emergency)**: Quick access to emergency procedures.
- **Checklist Harian**: Track daily oral hygiene tasks.
- **Edukasi Stroke**: Educational materials about stroke and oral health.
- **Video Demonstrasi**: Offline-ready video tutorials.

## Architecture

This project uses **Clean Architecture** with **BLoC** for state management.

### Structure

- `lib/core`: Shared resources (theme, constants, utils).
- `lib/features`: Feature-based modules.
  - `domain`: Entities, Repositories (Interfaces), Usecases.
  - `data`: Models, Repositories (Implementation), Data Sources.
  - `presentation`: BLoC, Pages, Widgets.
- `lib/injection`: Dependency Injection setup (GetIt).

## Setup

1.  Run `flutter pub get` to install dependencies.
2.  Run `flutter run` to start the app.

## Offline Capability

- **Text/Images**: Stored in `assets/`.
- **Videos**: Downloaded once and stored locally using `path_provider`.
- **Checklist**: Persisted using `Hive`.
