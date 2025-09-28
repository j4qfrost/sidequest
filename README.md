# SideQuest — Gamified Meetup App (AT Protocol)

SideQuest is a gamified meetup app built on the AT Protocol (atproto). It helps communities discover and join local meetups, earn points and badges for participation, and makes meetups more social and fun.

## What it does

- Connects to AT Protocol-compatible services for identity and social graph features.
- Lets organizers create events and quests (gameified tasks) for attendees.
- Tracks participation, awards points and badges, and displays leaderboards.
- Provides a mobile-friendly UI (Flutter) and cross-platform support for iOS, Android, macOS, Linux and the web.

## Key concepts

- Events: Meetups created by organizers with metadata (time, location, description).
- Quests: Small tasks or challenges attendees can complete at events to earn rewards.
- Rewards: Points, badges, and leaderboard positions that encourage participation.
- AT Protocol integration: Uses atproto for decentralized identity, posting, and invites.

## Getting started (developer)

Prerequisites:

- Flutter SDK (stable)
- Xcode (macOS, for iOS/macOS builds)
- Android SDK / Android Studio (for Android builds)

Quick steps:

1. Clone the repo

	git clone https://github.com/your-org/sidequest.git
	cd sidequest

2. Install Flutter packages

	flutter pub get

3. Run on your desired platform

	flutter run -d <device>

4. (Optional) Configure AT Protocol integration

- Provide your AT Protocol service endpoints or keys in `assets/config.json` or through environment variables. See the code and platform-specific docs for details on how identity and posting are wired.

## Usage (end users)

- Create or sign in with an AT Protocol-compatible identity.
- Browse local and upcoming meetups.
- Join events and accept quests.
- Complete quests during or after events to earn points and badges.
- Check leaderboards to see top contributors and attendees.

## Development notes

- Localization: Strings live under `assets/langs/` (e.g., `en-US.json`, `ja-JP.json`).
- Platform folders (android/, ios/, macos/, linux/) contain native build files and platform-specific configuration.
- The main Flutter entry point is `lib/main.dart`.

## Contributing

Contributions are welcome. If you're adding features or fixing bugs:

1. Fork the repository
2. Create a feature branch (e.g., `feat/quests`)
3. Add tests and update documentation

## License

This project is available under an open source license. Include your chosen license file in the repo (e.g., `LICENSE`).

## Acknowledgements

Special thanks to GitHub user `tacsotai` whose foundational work helped jumpstart this project.

If you use or adapt substantial amounts of code from the original project, please follow that project's license and attribution requirements.

---

Happy questing!