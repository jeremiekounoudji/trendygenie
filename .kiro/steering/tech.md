# Tech Stack

## Framework
- Flutter SDK >=3.4.3 <4.0.0
- Dart

## Backend
- Supabase (authentication, database, storage)
- Environment variables via `.env` file

## State Management
- GetX (`get: ^4.6.6`) - controllers, routing, dependency injection

## Key Dependencies
- `supabase_flutter` - Backend services
- `flutter_dotenv` - Environment config
- `google_fonts` - Typography (Lato, Pacifico)
- `cached_network_image` - Image caching
- `flutter_svg` - SVG support
- `geolocator` / `open_street_map_search_and_pick` - Location services
- `fl_chart` - Charts/analytics
- `carousel_slider` / `smooth_page_indicator` - UI carousels
- `image_picker` - Media selection
- `pin_code_fields` - OTP input

## Linting
- `flutter_lints` package (standard Flutter rules)

## Common Commands
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build for web
flutter build web

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Environment Setup
Create `.env` file with:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```
