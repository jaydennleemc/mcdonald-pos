# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a McDonald's POS (Point of Sale) iOS application built with SwiftUI. It's a restaurant ordering system that supports multiple users, food ordering, multiple payment methods, and settlement functions. The app uses SQLite.swift for local database storage.

## Build and Development Commands

**Using Xcode:**
- Open `McDonaldPOS.xcodeproj` in Xcode
- Select a simulator or device and click Run

**Using xcodebuild (CLI):**
```bash
# Build for simulator
xcodebuild -scheme McDonaldPOS -destination 'platform=iOS Simulator,name=iPhone 15'

# Build for device
xcodebuild -scheme McDonaldPOS -destination 'platform=iOS'

# Archive
xcodebuild -scheme McDonaldPOS -archivePath ./build/McDonaldPOS.xcarchive archive
```

**Using XcodeGen (if project.yml is used):**
```bash
# Generate Xcode project from project.yml
xcodegen generate
```

**Test Credentials:**
- Username: `staff`
- Password: `123456`

## High-Level Architecture

### Architecture Pattern: MVVM with SwiftUI

The app follows a SwiftUI MVVM architecture with environment objects for state management:

```
App Entry Point (McDonaldPOSApp.swift)
├── Environment Objects
│   ├── AuthViewModel (authentication state)
│   ├── CartViewModel (shopping cart state)
│   └── DatabaseManager (SQLite database operations)
│
├── Root View (ContentView)
│   ├── LoginView (when not authenticated)
│   └── MainTabView (when authenticated)
│       ├── CatalogView (menu browsing)
│       ├── CartView (order review & checkout)
│       └── SettingsView (user info & logout)
```

### Core Components

**1. ViewModels (State Management)**
- `AuthViewModel`: Handles user authentication, login/logout state
- `CartViewModel`: Manages cart items, calculates totals, handles add/remove operations
- `DatabaseManager`: SQLite.swift wrapper, handles all database operations (queries, data loading)

**2. Models (Data Structures)**
- `User`: User credentials and role
- `Catalog`: Menu categories (e.g., burgers, drinks)
- `Food`: Individual food items with pricing and category flags
- `BillItem`: Cart line items with optional meal options (main + side + drink)

**3. Views (SwiftUI)**
- `LoginView`: Authentication screen with username/password fields
- `CatalogView`: Displays food categories in horizontal scroll, food grid below
- `CartView`: Shows cart items with swipe-to-delete, payment method selection
- `SettingsView`: User profile and logout

**4. Extensions**
- `StringExtensions`: MD5 hashing for passwords, date parsing, bool conversion
- `SwiftUIExtensions`: Custom colors, fonts, spacing system, view modifiers (shake, pulse)

### Database Schema

The app uses SQLite with three main tables:

```sql
user (id, username, password, role, lastTime)
catalog (id, name_zh, name_en, image_zh, image_en, position)
food (id, catalogId, name_zh, name_en, image_zh, image_en, price, meal_price,
      is_breakfasts, is_set_meal, is_set_option, is_set_drink)
```

### Key Data Flow

1. **Login Flow**: `LoginView` → `AuthViewModel.login()` → `DatabaseManager.loginUser()` → authenticate with SQLite → update auth state

2. **Order Flow**:
   - `CatalogView` loads catalogs and foods from `DatabaseManager`
   - User selects food → `handleFoodSelection()` checks if meal (set_meal/breakfast)
   - If meal: opens `MealOptionSelectionView` → `MealDrinkSelectionView` → creates `BillItem` with options
   - If regular: creates `BillItem` directly and adds to `CartViewModel`

3. **Checkout Flow**: `CartView` → `PaymentView` → select payment method → process (simulated)

### Important Implementation Details

**Meal Selection Flow:**
- Meals require 3 selections: main food + option (side) + drink
- `is_set_meal` flag determines if food is a meal
- `is_set_option` flag filters side dishes
- `is_set_drink` flag filters drinks
- `is_breakfasts` flag separates breakfast vs regular meal options

**Price Calculation:**
- Regular items: use `food.price`
- Meals: sum `food.meal_price` + `option_food.meal_price` + `option_drink.meal_price`
- No tax applied in current implementation

**Security:**
- Passwords stored as MD5 hash (legacy approach, consider upgrading to bcrypt)
- SQL queries use parameterized queries via SQLite.swift to prevent injection

### Dependencies

- **SQLite.swift**: Database ORM and query builder
- **SwiftyJSON**: JSON parsing (likely for future API integration)
- **Toast-Swift**: Toast notifications (UI feedback)

### File Structure

```
mcdonald POS/
├── McDonaldPOSApp.swift          # App entry point, root views
├── StringExtensions.swift        # String utilities (MD5, date parsing)
├── SwiftUIExtensions.swift       # SwiftUI customizations (colors, fonts, modifiers)
├── Info.plist                    # App configuration
│
├── ViewModels/
│   ├── AuthViewModel.swift       # Authentication state
│   ├── CartViewModel.swift       # Cart state & calculations
│   └── DatabaseManager.swift     # SQLite operations
│
├── Views/
│   ├── LoginView.swift           # Login screen
│   ├── CatalogView.swift         # Menu browsing (with sub-views for meal selection)
│   ├── CartView.swift            # Cart & checkout (with PaymentView)
│   └── SettingsView.swift        # User settings
│
├── models/
│   ├── User.swift
│   ├── Catalog.swift
│   ├── Food.swift
│   └── BillItem.swift
│
└── project.yml                   # XcodeGen configuration
```

### Legacy Code Migration Notes

The project has undergone SwiftUI migration. Old UIKit files (in git history) were replaced:
- `AppDelegate.swift` / `SceneDelegate.swift` → `McDonaldPOSApp.swift`
- `LoginViewController` → `LoginView`
- `CatalogViewController` → `CatalogView`
- `CashierViewController` → `CartView`
- `SettingsViewController` → `SettingsView`
- `CashierTableViewCell` → `CartItemRow`
- `CatalogCollectionViewCell` → `FoodCell`, `CatalogCategoryCell`

### Future Development Notes

From README, planned features include:
- Sync restaurant database from remote system
- Support print receipt
- Settlement function (accounting)
- Upload orders to remote system

When adding these, consider:
- API integration patterns (likely using SwiftyJSON)
- Receipt printing (iOS AirPrint or thermal printer SDK)
- Remote sync (REST API or WebSocket)
- Settlement reporting (export to CSV/PDF)
