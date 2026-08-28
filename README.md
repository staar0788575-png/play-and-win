# Play and Win

A competitive gaming platform built with Flutter featuring live tournaments, real-time voice/video chat via Agora, prize redemption via Reloadly, and a Firebase backend.

## Features

- **User Authentication** — Email/password sign-up and login via Firebase Auth
- **Live Tournaments** — Browse, join, and compete in real-time tournaments
- **Voice/Video Chat** — In-game communication powered by Agora RTC Engine
- **Prize Redemption** — Redeem winnings for gift cards and mobile top-ups via Reloadly
- **Wallet System** — Track earnings, withdrawals, and transaction history
- **Push Notifications** — Tournament reminders and prize updates via Firebase Messaging
- **Leaderboards** — Global and tournament-specific rankings
- **User Profiles** — Track stats, achievements, and match history

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| Backend | Firebase (Auth, Firestore, Storage, Messaging) |
| Real-time Comms | Agora RTC Engine |
| Prize Redemption | Reloadly API |
| State Management | Provider |
| HTTP Client | Dio |

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
└── presentation/
    ├── screens/
    ├── widgets/
    └── providers/
```

## Getting Started

### Prerequisites

- Flutter SDK 3.5+
- Dart 3.5+
- A Firebase project with Authentication, Firestore, and Storage enabled
- An Agora developer account with an App ID and App Certificate
- A Reloadly account with client ID and secret

### Configuration

1. Add your Firebase configuration to `lib/core/constants/firebase_config.dart`
2. Add your Agora App ID to `lib/core/constants/agora_config.dart`
3. Add your Reloadly credentials to `lib/core/constants/reloadly_config.dart`

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

## License

This project is proprietary and confidential.
