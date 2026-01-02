# Project Structure

```
lib/
├── main.dart              # App entry, GetMaterialApp setup, route definitions
├── controllers/           # GetX controllers (business logic, state)
│   ├── auth_controller.dart
│   ├── business_controller.dart
│   ├── user_controller.dart
│   └── ...
├── models/                # Data models with fromJson/toJson
│   ├── enums.dart         # Shared enums (UserType, BusinessStatus, etc.)
│   ├── user_model.dart
│   ├── business_model.dart
│   └── ...
├── pages/                 # Screen widgets organized by feature
│   ├── authentication/    # Login, register, forgot password, certification
│   ├── home/              # Main home page with widgets/
│   ├── listing/           # Service/business listings
│   └── provider_dashboard/ # Provider management screens
├── services/              # External service integrations
│   └── supabase_service.dart
├── utils/                 # Utilities and constants
│   ├── globalVariable.dart  # Colors, CustomText widget, borders
│   └── global_variables.dart # Additional constants
├── widgets/               # Reusable UI components
│   ├── general_widgets/   # Common buttons, textfields, spacers
│   ├── auth/              # Auth-specific widgets
│   ├── business/          # Business cards
│   └── ...
└── global_widgets/        # App-wide shared widgets

assets/
├── icons/                 # SVG icons
└── images/                # Static images

db/                        # SQL migration files
docs/                      # Documentation and issue tracking
```

## Conventions

### Controllers
- Extend `GetxController`
- Use `.obs` for reactive variables
- Initialize via `Get.put()` in main.dart or lazily

### Models
- Include `fromJson` factory and `toJson` method
- Use snake_case for JSON keys, camelCase for Dart properties
- Define related enums in `models/enums.dart`

### Pages
- Each feature has its own folder under `pages/`
- Complex pages have a `widget/` subfolder for sub-components
- Use `StatefulWidget` or `StatelessWidget` with GetX bindings

### Widgets
- Reusable widgets go in `widgets/` or `global_widgets/`
- Use `CustomText` from `globalVariable.dart` for consistent typography
- Use predefined colors: `firstColor`, `secondColor`, `bgColor`, etc.

### Routing
- Named routes defined in `main.dart` via `getPages`
- Navigate with `Get.toNamed()`, `Get.offAllNamed()`, `Get.to()`
