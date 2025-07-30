
# ✅ Checklist iOS App – High-Level Overview

## 🎯 Goal (MVP Scope)

Replicate the web frontend with:
- Login + session management
- View/add/edit/delete to-do lists
- View/add/edit/delete to-do items
- Admin features (e.g., delete account)
- SwiftUI-based navigation
- Multi-environment support (Dev/UAT/Prod)
- Prepare for future offline mode

---

## 🧭 Build Order – Screens & Flow

1. **Splash/Launch Screen**
   - Check existing session
   - Route to Login or Main View

2. **Login View**
   - Email/password login
   - Save token + user info

3. **Main App Shell**
   - Tabs: `My Lists`, `Profile`
   - Shared layout using `NavigationStack` or `NavigationSplitView`

4. **To-Do List View**
   - Show all lists for user
   - Add/edit/delete lists
   - Tap list to drill down

5. **To-Do Item View**
   - Show items in selected list
   - Add/edit/delete items
   - Toggle complete

6. **Profile View**
   - Show user info, logout
   - If admin: delete accounts

---

## 🧱 Core Components

### 🔧 Models
- `User`: id, email, admin
- `Session`: token, expiry
- `ToDoList`: id, title, items
- `ToDoItem`: id, title, isDone, listId

---

### 📦 Repositories

#### API Repositories
- **AuthRepository**
  - `login(email, password) -> Session`
  - `logout()`
  - `getUserInfo() -> User`
- **ListRepository**
  - `getLists() -> [ToDoList]`
  - `createList(...)`, `deleteList(...)`
- **ItemRepository**
  - `getItems(for list)`
  - `createItem(...)`, `updateItem(...)`, `deleteItem(...)`

#### Local Storage
- **SessionManager**
  - Store session token + user info in `UserDefaults`
- **OfflineStorageManager** *(stub for now)*
  - Store lists/items for future offline use

---

### 🛠 Helpers

- **EnvironmentManager**
  - Handles env switching for base URLs (Dev/UAT/Prod)
- **APIClient**
  - Handles URLRequests, adds headers, decodes JSON
- **SessionTokenInterceptor**
  - Adds Bearer token, handles 401/403

---

## 🧠 ViewModels

| View           | ViewModel            |
|----------------|----------------------|
| Splash         | `SplashViewModel`    |
| Login          | `LoginViewModel`     |
| Lists          | `ToDoListsViewModel` |
| Items          | `ToDoItemsViewModel` |
| Profile        | `ProfileViewModel`   |

- Each follows `Model` + `ViewState`
- `createViewState(from:)` clean one-liner
- `model.didSet` triggers `viewState`

---

## 🧭 SwiftUI Navigation

Use modern SwiftUI stack:
- `NavigationStack` (iOS 16+)
- Use `NavigationLink(value:)` + `.navigationDestination(for:)`
- Use an `enum AppRoute: Hashable` to define navigation paths

```swift
enum AppRoute: Hashable {
    case list(ToDoList)
    case item(ToDoItem)
}
```

---

## 🌐 Networking Tools

- `URLSession` with `async/await`
- `Codable` models
- Custom error handling
- Optional `Result<T, AppError>` pattern

---

## 🔮 Future-Proofing & Stretch Goals

| Feature             | Notes                                         |
|---------------------|-----------------------------------------------|
| Offline Mode        | CoreData or SwiftData for local persistence   |
| Background Sync     | Periodic sync when network is available       |
| Biometric Login     | Use FaceID/TouchID to unlock saved sessions   |
| Push Notifications  | Triggered reminders (not MVP priority)        |
| SwiftData Support   | Optional alternative to CoreData              |

---
