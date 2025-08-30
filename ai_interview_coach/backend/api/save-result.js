const admin = require('firebase-admin');

// Initialize Firebase Admin (only if not already initialized)
if (!admin.apps.length) {
  try {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT || '{}');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    console.log('✅ Firebase Admin initialized');
  } catch (error) {
    console.warn('⚠️ Firebase Admin initialization failed:', error.message);
  }
}

module.exports = async (req, res) => {
  try {
    const { userId, question, answer, feedback } = req.body;

    if (!userId || !question || !answer || !feedback) {
      return res.status(400).json({ 
        error: 'Missing required fields: userId, question, answer, feedback' 
      });
    }

    // Check if Firebase is initialized
    if (!admin.apps.length || !process.env.FIREBASE_SERVICE_ACCOUNT) {
      return res.status(500).json({ 
        error: 'Firebase not configured - session not saved',
        saved: false
      });
    }

    const db = admin.firestore();
    
    // Prepare session data
    const sessionData = {
      question,
      answer,
      feedback,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      userId
    };

    // Save to Firestore
    const sessionRef = await db
      .collection('users')
      .doc(userId)
      .collection('sessions')
      .add(sessionData);

    console.log(`✅ Session saved for user ${userId}:`, sessionRef.id);

    res.json({
      success: true,
      sessionId: sessionRef.id,
      message: 'Session saved successfully'
    });

  } catch (error) {
    console.error('Error saving result:', error);
    
    res.status(500).json({ 
      error: 'Failed to save session',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error',
      saved: false
    });
  }
};