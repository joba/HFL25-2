# Hero Management System v4.0

A command-line application for managing superhero data with Firebase Firestore integration, ASCII art generation, and advanced filtering capabilities.

## 🦸 What It Does

The Hero Management System is a feature-rich terminal application that allows users to:

- **View and Browse Heroes**: Display hero information with detailed stats, biography, and ASCII art representations
- **Search Functionality**: Find heroes by name with case-insensitive search
- **Advanced Filtering**: Filter heroes by alignment (good/bad)
- **Sorting Options**: Sort heroes by strength, race or gender
- **Data Operations**: Create, read, and delete hero records
- **ASCII Art Integration**: Automatically convert hero images to ASCII art for terminal display
- **Cloud Storage**: Persistent data storage using Firebase Firestore
- **Image Management**: Download and cache hero images locally

## 🚀 Features

### Technical Features

- **Singleton Pattern**: Efficient data manager with single instance
- **Error Handling**: Graceful error handling for network and data operations
- **Environment Configuration**: Secure API key management via .env files
- **Unit Testing**: Comprehensive test suite with mocked data
- **CI/CD Ready**: GitHub Actions integration for automated testing

## 📁 File Structure

```
v04/
├── lib/
│   ├── firebase_config.dart          # Firebase configuration and initialization
│   ├── v04.dart                      # Main application entry point and UI
│   ├── managers/
│   │   ├── api_manager.dart          # Remote API management
│   │   ├── image_manager.dart        # Image download management
│   │   ├── firestore_data_manager.dart  # Firebase Firestore operations
│   │   └── hero_data_managing.dart   # Abstract interface for data management
│   └── models/
│       ├── hero_model.dart           # Hero data model with all properties
│       └── search_model.dart         # Api response model
├── test/
│   ├── heroes-mock.json             # Mock data for unit testing
│   ├── v04_test.dart                # Application unit tests
├── images/                          # Local hero image cache directory
├── .env                             # Environment variables (not in repo)
├── .gitignore                       # Git ignore rules
├── pubspec.yaml                     # Dart dependencies and metadata
└── README.md                        # This documentation
```

## 🛠️ Installation & Setup

### Prerequisites

- Dart SDK 3.9.2 or higher
- Firebase project with Firestore enabled
- Superheroapi.com access token
- Internet connection for image downloads

### Setup Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/joba/HFL25-2.git
   cd v04
   ```

2. **Install dependencies**

   ```bash
   dart pub get
   ```

3. **Configure Firebase**
   Create a `.env` file in the project root:

   ```env
   FIREBASE_API_KEY=firebase-api-key
   FIREBASE_AUTH_DOMAIN=firebase-auth-domain
   FIREBASE_PROJECT_ID=firebase-project-id
   FIREBASE_STORAGE_BUCKET=firebase-storage-bucket
   FIREBASE_MESSAGING_SENDER_ID=firebase-messaging-sender-id
   FIREBASE_APP_ID=firebase-app-id
   ```

4. **Run the application**
   ```bash
   dart run
   ```

## 📚 Code Documentation

### Core Classes

#### `HeroModel`

The main data model representing a superhero with complete information:

- **Powerstats**: Intelligence, strength, speed, durability, power, combat
- **Biography**: Full name, alter egos, aliases, place of birth, publisher, alignment (good/bad)
- **Appearance**: Gender, race, height, weight, eye color, hair color
- **Work**: Occupation and base of operations
- **Connections**: Group affiliations and relatives
- **Image**: URL and ASCII art representation

#### `FirestoreHeroDataManager`

Singleton class managing all Firebase Firestore operations:

- **Data Operations**: Create, read, delete heroes
- **Data Conversion**: Handles Firestore format conversion
- **Local Caching**: Maintains local hero list for performance
- **Filtering & Sorting**: Advanced data manipulation capabilities

#### `ApiManager`

Handles external API interactions and image downloading:

- **Image Downloads**: Fetches remote hero images with proper headers
- **Local Storage**: Saves images locally for ASCII conversion
- **Caching Logic**: Prevents unnecessary re-downloads

#### `ImageManager`

Handles image processing:

- **ASCII Art Generation**: Converts images to terminal-friendly ASCII art

#### `FirebaseConfig`

Configuration management for Firebase services:

- **Environment Loading**: Secure credential management via .env files
- **URL Construction**: Dynamic Firestore URL generation
- **Validation**: Ensures required configuration is present

### Key Methods

#### Data Management

```dart
// Load heroes from Firestore
Future<void> loadHeroes()

// Search heroes by name
Future<List<HeroModel>> searchHeroes(String searchTerm)

// Filter heroes by property
List<HeroModel> filterHeroes(String? filterBy, String? filterValue)

// Sort heroes by criteria
List<HeroModel> sortHeroes(String? sortBy, [int? limit])
```

#### Image Processing

```dart
// Download and save hero image
Future<String> downloadAndSaveHeroImage(String heroId, String imageUrl)

// Convert image to ASCII art
Future<String> convertImage(String? filePath)

// Check for local image
bool hasLocalHeroImage(String heroId)
```

## 🧪 Testing

### Unit Tests

Comprehensive test suite covering:

- Hero data filtering and sorting
- Search functionality
- Error handling scenarios
- Mock data validation

### Running Tests

```bash
# Run all tests
dart test
```

### Test Data

Mock data is provided in `test/heroes-mock.json` for consistent testing without external dependencies.

## 🔧 Configuration

### Environment Variables

Required environment variables in `.env`:

```env
SUPERHERO_API_KEY=your-api-key
FIREBASE_API_KEY=firebase-api-key
FIREBASE_AUTH_DOMAIN=firebase-auth-domain
FIREBASE_PROJECT_ID=firebase-project-id
FIREBASE_STORAGE_BUCKET=firebase-storage-bucket
FIREBASE_MESSAGING_SENDER_ID=firebase-messaging-sender-id
FIREBASE_APP_ID=firebase-app-id
```

### Dependencies

Key dependencies defined in `pubspec.yaml`:

- `ascii_art_converter`: Image to ASCII art conversion
- `cli_spin`: Loading spinners for better UX
- `cli_table`: Formatted table display
- `dotenv`: Environment variable management
- `http`: HTTP requests for API calls

## 🚀 Usage Examples

### Viewing Heroes

```
1. View Heroes
   └── Displays all heroes sorted by strength
   └── Shows ASCII art, stats, and biography

2. Filter Options
   ├── Top 3 strongest heroes
   ├── Heroes only (good alignment)
   ├── Villains only (bad alignment)
   ├── Sort by race
   └── Sort by gender
```

### Searching Heroes

```
2. Search Heroes
   └── Enter hero name (case-insensitive)
   └── Returns matching heroes with limited details
```

## 📈 Performance Considerations

- **Lazy Loading**: Heroes are loaded only when needed
- **Local Caching**: Images cached locally to avoid re-downloads
- **Singleton Pattern**: Single data manager instance
- **Efficient Filtering**: In-memory operations after initial load
- **Async Operations**: Non-blocking I/O for better user experience

## 🔒 Security

- Environment variables for sensitive configuration
- No hardcoded API keys or credentials
- Secure Firestore REST API usage
- Error handling without exposing sensitive information
