# Shopping Cart - AnimatedList Widget Demo

A Flutter application demonstrating smooth item animations in a shopping cart using `AnimatedList` widget with fade and slide transitions.

## Quick Start

1. Ensure Flutter is installed: `flutter --version`
2. Get dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Three Key Attributes

### 1. AnimatedList Widget
The core of this app uses Flutter's `AnimatedList` to manage cart items with automatic animations. When items are added or removed, the list animates them in/out smoothly without rebuilding the entire list—only the affected item animates.

Implementation: Items are managed through `AnimatedList.insertItem()` and `removeItem()` methods with custom durations:
- Insert animation: 500ms
- Remove animation: 400ms

### 2. Custom Animations (Fade & Slide)
Each cart item uses a combination of animations to create a polished UX:
- SlideTransition: Items slide in from left (`Offset(-1, 0)`) with ease-out curve
- FadeTransition: Opacity animates smoothly alongside the slide
- These are wrapped as a single animated widget using `_buildCartTile()`

### 3. State Management with GlobalKey
The app uses a `GlobalKey<AnimatedListState>` to control the AnimatedList directly:
```dart
final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
```
This allows imperative control of animations while maintaining reactive state (`setState`). A Set tracks which catalog items are already in the cart to prevent duplicates.

## Features

- Add items from the bottom sheet catalog
- Remove items with animated sliding transition
- Real-time cart total calculation
- Visual feedback with snackbars and item count badge
- Empty state with helpful messaging

## Screenshots

<img width="238" height="431" alt="animatedlist widget" src="https://github.com/user-attachments/assets/7ff7cbf2-106a-4e6b-ad7a-82cbc02ea6e8" />




Note: This project is built with Flutter and uses Material Design 3 for a modern, responsive UI.



In-Class Presentation Date:  February 24, 2026
