const axios = require('axios');

const OPENAI_SYSTEM_PROMPT = `You are an expert interview coach analyzing interview responses. Provide feedback in STRICT JSON format only.

Analyze the response for:
1. Tone (confident, nervous, unsure, neutral)
2. Filler words (um, uh, like, you know, etc.)
3. Grammar issues
4. Relevance to the question
5. Overall score (0-10)
6. Improvement suggestions
7. One follow-up question

Respond ONLY with this exact JSON structure:
{
  "tone": "confident|nervous|unsure|neutral",
  "fillerWords": ["word1", "word2"],
  "grammarIssues": ["issue1", "issue2"],
  "relevance": "brief comment on relevance",
  "score": 0-10,
  "suggestions": "concise improvement tips",
  "followUp": "one relevant follow-up question"
}`;

module.exports = async (req, res) => {
  try {
    const { question, answer } = req.body;

    if (!question || !answer) {
      return res.status(400).json({ 
        error: 'Missing required fields: question and answer' 
      });
    }

    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ 
        error: 'OpenAI API key not configured' 
      });
    }

    // Prepare OpenAI request
    const openaiRequest = {
      model: 'gpt-4',
      messages: [
        {
          role: 'system',
          content: OPENAI_SYSTEM_PROMPT
        },
        {
          role: 'user',
          content: `Interview Question: "${question}"\n\nCandidate Response: "${answer}"\n\nProvide analysis in the specified JSON format.`
        }
      ],
      temperature: 0.7,
      max_tokens: 800
    };

    // Call OpenAI API
    const openaiResponse = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      openaiRequest,
      {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000
      }
    );

    let analysisResult;
    try {
      const content = openaiResponse.data.choices[0].message.content.trim();
      
      // Try to parse JSON directly
      analysisResult = JSON.parse(content);
    } catch (parseError) {
      console.warn('Failed to parse OpenAI response as JSON:', parseError.message);
      
      // Fallback: Extract JSON from response using regex
      const content = openaiResponse.data.choices[0].message.content;
      const jsonMatch = content.match(/\{[\s\S]*\}/);
      
      if (jsonMatch) {
        try {
          analysisResult = JSON.parse(jsonMatch[0]);
        } catch (fallbackError) {
          throw new Error('Unable to parse AI response as JSON');
        }
      } else {
        throw new Error('No JSON found in AI response');
      }
    }

    // Validate response structure
    const requiredFields = ['tone', 'fillerWords', 'grammarIssues', 'relevance', 'score', 'suggestions', 'followUp'];
    const missingFields = requiredFields.filter(field => !(field in analysisResult));
    
    if (missingFields.length > 0) {
      console.warn('AI response missing fields:', missingFields);
      
      // Provide fallback values for missing fields
      const fallbackResponse = {
        tone: analysisResult.tone || 'neutral',
        fillerWords: Array.isArray(analysisResult.fillerWords) ? analysisResult.fillerWords : [],
        grammarIssues: Array.isArray(analysisResult.grammarIssues) ? analysisResult.grammarIssues : [],
        relevance: analysisResult.relevance || 'Response addresses the question appropriately',
        score: typeof analysisResult.score === 'number' ? analysisResult.score : 7,
        suggestions: analysisResult.suggestions || 'Continue practicing to improve your interview skills',
        followUp: analysisResult.followUp || 'Can you provide a specific example to support your answer?'
      };
      
      analysisResult = fallbackResponse;
    }

    // Ensure score is within valid range
    if (typeof analysisResult.score !== 'number' || analysisResult.score < 0 || analysisResult.score > 10) {
      analysisResult.score = Math.max(0, Math.min(10, parseInt(analysisResult.score) || 7));
    }

    res.json(analysisResult);

  } catch (error) {
    console.error('Error analyzing response:', error);
    
    if (error.response?.status === 401) {
      return res.status(401).json({ error: 'Invalid OpenAI API key' });
    }
    
    if (error.code === 'ECONNABORTED' || error.message.includes('timeout')) {
      return res.status(504).json({ error: 'Request timeout - please try again' });
    }

    res.status(500).json({ 
      error: 'Failed to analyze response',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
};