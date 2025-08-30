# AI Interview Coach Backend

Node.js Express API for the AI Interview Coach application.

## 🚀 Quick Start

```bash
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

## 🔧 Environment Variables

Create a `.env` file with:

```env
OPENAI_API_KEY=sk-your-openai-api-key
FIREBASE_SERVICE_ACCOUNT='{"type": "service_account", "project_id": "..."}'
PORT=3000
NODE_ENV=development
```

## 📡 API Endpoints

### `GET /api/health`
Health check endpoint.

### `POST /api/analyze-response`
Analyzes interview responses using OpenAI GPT.

**Request Body:**
```json
{
  "question": "Tell me about yourself",
  "answer": "I am a software engineer..."
}
```

**Response:**
```json
{
  "tone": "confident",
  "fillerWords": ["um", "like"],
  "grammarIssues": [],
  "relevance": "Highly relevant",
  "score": 8,
  "suggestions": "Add specific achievements",
  "followUp": "Can you share a specific project?"
}
```

### `POST /api/save-result`
Saves interview session to Firestore.

### `GET /api/history?userId={uid}`
Retrieves user's session history.

## 🚀 Deployment to Vercel

1. Push to GitHub
2. Connect repo to Vercel
3. Set environment variables in Vercel dashboard
4. Deploy

## 🧪 Testing

```bash
npm test
```

## 📝 Development

```bash
npm run dev  # Start with nodemon
```