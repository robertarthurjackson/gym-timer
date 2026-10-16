# Gym Timer

A free iPhone app with no ads, no fees, no accounts and no tracking. It works like
"Gym Sets Counter" by NDroid (Android only), with its own design.

## Modes (same as the original)

1. **Rep Sets**: choose how many sets and how long to rest. Tap **Set Done** after each
   set. The set counter goes up and a rest countdown starts. When rest ends, the phone
   beeps and vibrates.
2. **Timed Sets**: choose sets, work time and rest time. The app runs
   work → rest → work … by itself and alerts you at each change.
3. **Custom Time**: one countdown with any time you choose (for planks, stretches and
   similar), with presets and a repeat button.

## Design

- Dark, high-contrast UI with large numbers you can read from across the bench.
- A big progress ring and a set counter ("Set 3 of 5").
- Large tap targets you can hit with sweaty hands.
- The screen stays awake during a session.
- Alerts use sound and haptics, and play over your music without stopping it.

## Web app (the public version)

Live at https://robroth.ca/gym-timer/. It's a single static page in `docs/` that GitHub
Pages serves from this repo. On iPhone: open the link in Safari, tap Share, then
Add to Home Screen. It works offline through a service worker. Compared with the native app,
it has no vibration on iPhone and no alerts while the phone is locked.

## Native iOS app (personal sideload only)

## Tech

- SwiftUI, iOS 17+, no third-party dependencies.
- Settings are saved with `@AppStorage`.
- Source files are in `GymTimer/`.

## Building

1. In Xcode: File → New → Project → iOS App, name it `GymTimer` and choose SwiftUI.
2. Replace the generated Swift files with the files in `GymTimer/`.
3. Run it on your iPhone. A free Apple ID works for personal installs, which expire after
   7 days. App Store release needs the paid $99/yr developer program.

## TODO

- Background notifications so rest alerts fire when the app is closed.
- Lock Screen / Dynamic Island Live Activity.
- App icon.
