# AI Interview Coach

A comprehensive AI-powered interview practice application built with Flutter (cross-platform frontend) and Node.js (backend API). Practice interview skills with voice or text input, receive detailed AI feedback, and track your progress over time.

## 📱 Features

### Frontend (Flutter)
- **Multi-platform Support**: Android, iOS, and Web deployment
- **Firebase Authentication**: Email/Password and Google Sign-In
- **Voice & Text Practice**: Speech-to-text integration for natural practice
- **AI-Powered Feedback**: Detailed analysis of tone, grammar, relevance, and more
- **Session History**: Track progress and review past sessions
- **Material 3 Design**: Modern, responsive UI with dark/light theme support
- **Progress Tracking**: Statistics, streaks, and improvement analytics

### Backend (Node.js + Express)
- **OpenAI Integration**: GPT-powered response analysis
- **Firebase Admin**: Secure server-side Firestore operations
- **RESTful API**: Clean endpoints for analysis, saving, and history
- **Vercel Ready**: Optimized for serverless deployment
- **Error Handling**: Comprehensive error management and validation

## 🏗️ Architecture

```
ai_interview_coach/
├── frontend/              # Flutter cross-platform app
│   ├── lib/
│   │   ├── screens/       # UI screens and widgets
│   │   ├── providers/     # State management (Provider pattern)
│   │   ├── models/        # Data models
│   │   ├── services/      # API and external service integrations
│   │   ├── utils/         # Utilities and themes
│   │   └── config/        # App configuration
│   ├── android/          # Android-specific files
│   ├── ios/              # iOS-specific files
│   ├── web/              # Web-specific files
│   └── pubspec.yaml      # Flutter dependencies
├── backend/              # Node.js Express API
│   ├── api/              # API route handlers
│   ├── package.json      # Node.js dependencies
│   ├── vercel.json       # Vercel deployment config
│   └── index.js          # Server entry point
└── README.md            # This file
```

## 🚀 Quick Start Guide

### Prerequisites

Before starting, ensure you have:
- **Flutter SDK** (3.16 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Node.js** (18 or higher) - [Install Node.js](https://nodejs.org/)
- **Firebase Project** - [Create Firebase Project](https://console.firebase.google.com/)
- **OpenAI API Key** - [Get API Key](https://platform.openai.com/api-keys)
- **Git** - [Install Git](https://git-scm.com/downloads)

### Step 1: Clone and Setup Project

```bash
# Clone the repository
git clone <your-repository-url>
cd ai_interview_coach

# Or if starting fresh, create the directory structure as provided
```

### Step 2: Backend Setup (Node.js API)

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env file with your keys (see configuration section below)
nano .env  # or use your preferred editor
```

**Environment Configuration (.env file):**
```env
OPENAI_API_KEY=sk-your-openai-api-key-here
FIREBASE_SERVICE_ACCOUNT='{"type": "service_account", "project_id": "your-project-id", "private_key": "-----BEGIN PRIVATE KEY-----\n...", ...}'
PORT=3000
NODE_ENV=development
```

**Start the backend server:**
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The backend API will be available at: `http://localhost:3000`

### Step 3: Firebase Configuration

#### 3.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable **Authentication** and **Firestore Database**
4. In Authentication, enable Email/Password and Google Sign-In providers

#### 3.2 Get Firebase Service Account (for Backend)
1. Go to Project Settings → Service Accounts
2. Click "Generate new private key"
3. Copy the entire JSON content into your backend `.env` file as `FIREBASE_SERVICE_ACCOUNT`

#### 3.3 Configure Flutter Firebase
```bash
# Install Firebase CLI if not installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Navigate to frontend directory
cd frontend

# Configure Firebase for Flutter
flutterfire configure
```

This will generate `lib/firebase_options.dart` with your Firebase configuration.

### Step 4: Frontend Setup (Flutter)

```bash
# Ensure you're in the frontend directory
cd frontend

# Create assets directories (if not already created)
mkdir -p assets/images assets/animations fonts

# Install Flutter dependencies
flutter pub get

# Check Flutter installation
flutter doctor

# Run the app in development mode
flutter run --dart-define=API_BASE=http://localhost:3000
```

**For different platforms:**
```bash
# Run on specific platform
flutter run -d chrome --dart-define=API_BASE=http://localhost:3000  # Web
flutter run -d "iPhone Simulator"  # iOS Simulator
flutter run -d emulator-5554  # Android Emulator
```

## 🌐 Production Deployment

### Deploy Backend to Vercel

#### Method 1: GitHub Integration (Recommended)
1. **Push your code to GitHub:**
   ```bash
   git add .
   git commit -m "Initial AI Interview Coach setup"
   git push origin main
   ```

2. **Deploy to Vercel:**
   - Visit [vercel.com](https://vercel.com) and sign in
   - Click "Import Project" → Import from GitHub
   - Select your repository
   - **Important**: Set the root directory to `backend`
   - Configure environment variables in Vercel dashboard:
     - `OPENAI_API_KEY`: Your OpenAI API key
     - `FIREBASE_SERVICE_ACCOUNT`: Your Firebase service account JSON (copy the entire JSON as a string)
     - `NODE_ENV`: `production`
   - Deploy

3. **Get your API URL:**
   Your API will be available at: `https://your-project-name.vercel.app`

#### Method 2: Vercel CLI
```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to backend directory
cd backend

# Deploy
vercel --prod

# Set environment variables
vercel env add OPENAI_API_KEY
vercel env add FIREBASE_SERVICE_ACCOUNT
```

### Deploy Frontend

#### Web Deployment (Firebase Hosting)
```bash
cd frontend

# Build for web with production API
flutter build web --dart-define=API_BASE=https://your-vercel-app.vercel.app

# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Initialize Firebase hosting
firebase init hosting

# Select the build/web directory when prompted

# Deploy
firebase deploy --only hosting
```

#### Mobile App Deployment

**Android APK/Bundle:**
```bash
cd frontend

# Build APK for testing
flutter build apk --release --dart-define=API_BASE=https://your-vercel-app.vercel.app

# Build App Bundle for Play Store
flutter build appbundle --release --dart-define=API_BASE=https://your-vercel-app.vercel.app
```

**iOS App:**
```bash
cd frontend

# Build for iOS
flutter build ios --release --dart-define=API_BASE=https://your-vercel-app.vercel.app

# Open in Xcode for further configuration and App Store deployment
open ios/Runner.xcworkspace
```

## 🔧 Configuration Details

### API Base URL Configuration

The app uses the `--dart-define` flag to set the API base URL:

- **Development**: `http://localhost:3000`
- **Production**: `https://your-vercel-app.vercel.app`

This is configured in `lib/config/app_config.dart`:
```dart
static const String apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://localhost:3000',
);
```

### Firebase Security Rules

For Firestore, use these security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/sessions/{sessionId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📡 API Documentation

### Endpoints

#### `POST /api/analyze-response`
Analyzes an interview response using OpenAI GPT.

**Request:**
```json
{
  "question": "Tell me about yourself",
  "answer": "I am a software engineer with 5 years of experience..."
}
```

**Response:**
```json
{
  "tone": "confident",
  "fillerWords": ["um", "like"],
  "grammarIssues": [],
  "relevance": "Highly relevant and well-structured response",
  "score": 8,
  "suggestions": "Consider adding specific achievements",
  "followUp": "Can you share a specific project you're proud of?"
}
```

#### `POST /api/save-result`
Saves interview session to Firestore.

**Request:**
```json
{
  "userId": "firebase-uid",
  "question": "Interview question",
  "answer": "User's answer",
  "feedback": { "tone": "confident", ... }
}
```

#### `GET /api/history?userId={uid}`
Retrieves user's interview session history.

#### `GET /api/health`
Health check endpoint returning system status.

## 🧪 Testing

### Backend Testing
```bash
cd backend
npm test
```

### Frontend Testing
```bash
cd frontend
flutter test
```

### Manual Testing Checklist

- [ ] Authentication (Email/Password and Google Sign-In)
- [ ] Voice recording and speech-to-text
- [ ] Text input and submission
- [ ] AI feedback generation
- [ ] Session saving and history
- [ ] Theme switching
- [ ] Cross-platform compatibility

## 🔐 Security Considerations

### Production Security Checklist

- [ ] **API Keys**: Never commit API keys to version control
- [ ] **Firebase Rules**: Implement proper Firestore security rules
- [ ] **CORS**: Configure appropriate CORS policies for production
- [ ] **HTTPS**: Ensure all production deployments use HTTPS
- [ ] **Input Validation**: Validate all user inputs on both client and server
- [ ] **Rate Limiting**: Implement rate limiting for API endpoints
- [ ] **Error Handling**: Don't expose sensitive error details in production

### Environment Variables Security

**Never commit these to Git:**
- OpenAI API keys
- Firebase service account credentials
- Any production configuration

Use `.env` files for local development and platform environment variable settings for production.

## 🎯 Development Workflow

### Local Development
```bash
# Terminal 1: Start backend
cd backend
npm run dev

# Terminal 2: Start Flutter
cd frontend
flutter run --dart-define=API_BASE=http://localhost:3000
```

### Before Committing
```bash
# Run tests
cd backend && npm test
cd frontend && flutter test

# Check Flutter code quality
cd frontend && flutter analyze

# Format code
cd frontend && dart format .
```

### Git Workflow
```bash
git add .
git commit -m "feat: describe your changes"
git push origin main

# Deploy automatically triggers via Vercel GitHub integration
```

## 🚀 Performance Optimization

### Frontend Optimizations
- **Images**: Use optimized images and proper sizing
- **State Management**: Efficient use of Provider pattern
- **Build Size**: Use `--split-debug-info` and `--obfuscate` for production builds
- **Caching**: Implement proper caching for API responses

### Backend Optimizations
- **Cold Starts**: Vercel serverless functions optimize for cold starts
- **Response Time**: Use efficient OpenAI prompt engineering
- **Database**: Optimize Firestore queries and indexing

## 🆘 Troubleshooting

### Common Issues

#### Flutter Issues
```bash
# Clean build
flutter clean
flutter pub get

# Fix platform issues
cd ios && pod install && cd ..  # iOS
flutter doctor  # Check for issues
```

#### Firebase Issues
```bash
# Reconfigure Firebase
flutterfire configure

# Check Firebase project settings
firebase projects:list
```

#### Backend Issues
```bash
# Check environment variables
node -e "console.log(process.env.OPENAI_API_KEY ? 'OpenAI configured' : 'Missing OpenAI key')"

# Test API endpoints
curl http://localhost:3000/api/health
```

### Performance Issues
- **Slow API responses**: Check OpenAI API quotas and network
- **App crashes**: Check device logs and Firebase Crashlytics
- **Build failures**: Ensure all dependencies are correctly installed

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make changes and test thoroughly
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push to branch: `git push origin feature/amazing-feature`
6. Create a Pull Request

### Code Style
- **Flutter**: Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- **Node.js**: Use ESLint configuration provided
- **Commits**: Use conventional commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **OpenAI** for providing GPT API for intelligent feedback
- **Firebase** for authentication and database services
- **Flutter** team for the excellent cross-platform framework
- **Vercel** for seamless serverless deployment

## 📞 Support

### Getting Help
- **GitHub Issues**: Report bugs and request features
- **Discussions**: Ask questions in GitHub Discussions
- **Documentation**: Check this README for detailed setup instructions

### Contact
- **Email**: your-email@domain.com
- **Twitter**: @yourusername
- **LinkedIn**: your-profile

---

**Built with ❤️ using Flutter and Node.js**

## 📸 Screenshots Placeholders

*Note: Add actual screenshots after deployment*

### 🎨 Assets Structure

```
frontend/assets/
├── images/
│   ├── app_logo.png          # App logo (currently using Icons.psychology)
│   ├── google_logo.png       # Google sign-in logo (currently using Icons.login)
│   └── .gitkeep
├── animations/
│   └── .gitkeep              # For future Lottie animations
└── fonts/
    └── .gitkeep              # For custom fonts (currently using system fonts)
```

### 📱 Mobile Screens
![Login Screen](screenshots/mobile-login.png)
![Dashboard](screenshots/mobile-dashboard.png)
![Voice Practice](screenshots/mobile-voice-practice.png)
![Feedback Screen](screenshots/mobile-feedback.png)

### 💻 Web Interface
![Web Dashboard](screenshots/web-dashboard.png)
![Interview Practice](screenshots/web-interview.png)
![History View](screenshots/web-history.png)

### 🖥️ Desktop Views
![Desktop App](screenshots/desktop-overview.png)

*Screenshots will be added once the application is fully deployed and tested across platforms.*