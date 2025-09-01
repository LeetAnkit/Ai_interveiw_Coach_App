const express = require("express");
const { GoogleGenerativeAI } = require("@google/generative-ai");

const router = express.Router();

// ✅ Initialize Gemini client
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// ✅ Use latest stable Gemini model
const model = genAI.getGenerativeModel({
  model: "gemini-2.0-flash"
});

router.post("/", async (req, res) => {
  try {
    const { answer } = req.body;

    if (!answer) {
      return res.status(400).json({ error: "Missing interview answer in request body" });
    }

    const prompt = `
    Analyze the following interview answer and provide:
    1. Feedback on clarity, tone, and grammar.
    2. A score out of 10.
    3. A follow-up interview question.

    Answer: "${answer}"
    `;

    const result = await model.generateContent({
      contents: [
        { parts: [{ text: prompt }] }
      ]
    });

    const responseText =
      result.response?.candidates?.[0]?.content?.parts?.[0]?.text ||
      "No response generated";

    res.json({
      success: true,
      analysis: responseText
    });
  } catch (error) {
    console.error("❌ Error in /api/analyze-response:", error);
    res.status(500).json({
      error: "Failed to analyze interview response",
      details: error.message
    });
  }
});

module.exports = router;
