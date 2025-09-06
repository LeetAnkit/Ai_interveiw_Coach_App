// 

const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const dotenv = require("dotenv");
dotenv.config();

// ✅ Initialize Firebase Admin before anything that needs it
require("./firebaseAdmin");

// ✅ Gemini SDK (CommonJS)
const { GoogleGenerativeAI } = require("@google/generative-ai");
if (!process.env.GEMINI_API_KEY) {
  console.error("❌ Missing GEMINI_API_KEY in .env");
  process.exit(1);
}
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const app = express();
const PORT = process.env.PORT || 3000;

// 🔹 Allowed origins for Flutter web dev + production
const allowedOrigins = (
  process.env.ALLOWED_ORIGINS ||
  "http://localhost:3000,http://localhost:8080,http://127.0.0.1:8080,http://localhost:5173,http://127.0.0.1:5173,http://localhost:52531,http://localhost:61238"
).split(",");

// 🔹 Security + CORS
app.use(helmet());
app.use(
  cors({
    origin: function (origin, cb) {
      if (!origin) return cb(null, true); // e.g. mobile apps / curl
      if (allowedOrigins.includes(origin)) return cb(null, true);

      // ⚠️ In dev mode, allow everything
      if (process.env.NODE_ENV === "development") {
        console.warn(`⚠️ Allowing unlisted origin in dev: ${origin}`);
        return cb(null, true);
      }

      return cb(new Error("❌ Not allowed by CORS: " + origin));
    },
    credentials: true,
  })
);

// 🔹 Parse body
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// 🔹 Routes
app.get("/", (req, res) => {
  res.json({
    message: "AI Interview Coach Backend API",
    version: "1.0.0",
    status: "running",
  });
});

app.get("/api/health", require("./api/health"));

// ✅ Analyze-response route (with Gemini)
app.post("/api/analyze-response", async (req, res) => {
  try {
    const { question, answer } = req.body;

    if (!question || !answer) {
      return res.status(400).json({
        error: "Missing required fields: question and answer",
      });
    }

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

    const prompt = `
    You are an expert interview coach analyzing interview responses.
    Respond ONLY in this JSON format:
    {
      "tone": "confident|nervous|unsure|neutral",
      "fillerWords": ["word1", "word2"],
      "grammarIssues": ["issue1", "issue2"],
      "relevance": "brief comment on relevance",
      "score": 0-10,
      "suggestions": "concise improvement tips",
      "followUp": "one relevant follow-up question"
    }

    Interview Question: "${question}"
    Candidate Response: "${answer}"
    `;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    let parsed;
    try {
      parsed = JSON.parse(text);
    } catch (e) {
      console.warn("⚠️ Gemini did not return pure JSON, fallback applied");
      const jsonMatch = text.match(/\{[\s\S]*\}/);
      parsed = jsonMatch ? JSON.parse(jsonMatch[0]) : { raw: text };
    }

    res.json(parsed);
  } catch (error) {
    console.error("❌ Error in /api/analyze-response:", error.message);
    res.status(500).json({
      error: "Failed to analyze response",
      message:
        process.env.NODE_ENV === "development"
          ? error.message
          : "Internal server error",
    });
  }
});

// ✅ Protected routes (Firebase Auth)
const authenticate = require("./middleware/auth");

try {
  app.post("/api/save-result", authenticate, require("./api/save-result"));
} catch (e) {
  console.error("❌ save-result route not implemented:", e.message);
  app.post("/api/save-result", authenticate, (req, res) =>
    res.status(501).json({ error: "save-result not implemented" })
  );
}

try {
  app.get("/api/history", authenticate, require("./api/history"));
} catch (e) {
  console.error("❌ history route not implemented:", e.message);
  app.get("/api/history", authenticate, (req, res) =>
    res.status(501).json({ error: "history not implemented" })
  );
}

// 🔹 Error handler
app.use((err, req, res, next) => {
  console.error("🔥 Error:", err?.message || err);
  res.status(500).json({
    error: "Internal server error",
    message:
      process.env.NODE_ENV === "development"
        ? err?.message || String(err)
        : "Something went wrong",
  });
});

// 🔹 404 handler
app.use((req, res) =>
  res.status(404).json({ error: "Endpoint not found" })
);

// 🔹 Start server
app.listen(PORT, () => {
  console.log(`🚀 Backend running on http://localhost:${PORT}`);
  console.log(`📡 Environment: ${process.env.NODE_ENV || "development"}`);
  console.log(
    `🔑 Gemini API: ${process.env.GEMINI_API_KEY ? "✅ Configured" : "❌ Missing"}`
  );
  console.log(
    `🔥 Firebase service account: ${
      process.env.FIREBASE_SERVICE_ACCOUNT ? "✅ Present" : "❌ Missing"
    }`
  );
});

module.exports = app;
