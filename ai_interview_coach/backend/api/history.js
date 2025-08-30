const admin = require('firebase-admin');

module.exports = async (req, res) => {
  try {
    const { userId } = req.query;
    const limit = parseInt(req.query.limit) || 20;

    if (!userId) {
      return res.status(400).json({ 
        error: 'Missing userId parameter' 
      });
    }

    // Check if Firebase is initialized
    if (!admin.apps.length || !process.env.FIREBASE_SERVICE_ACCOUNT) {
      return res.status(500).json({ 
        error: 'Firebase not configured',
        sessions: []
      });
    }

    const db = admin.firestore();
    
    // Get user sessions
    const sessionsRef = db
      .collection('users')
      .doc(userId)
      .collection('sessions')
      .orderBy('createdAt', 'desc')
      .limit(limit);

    const snapshot = await sessionsRef.get();
    
    const sessions = [];
    snapshot.forEach(doc => {
      const data = doc.data();
      sessions.push({
        id: doc.id,
        ...data,
        createdAt: data.createdAt?.toDate?.()?.toISOString() || null
      });
    });

    console.log(`📚 Retrieved ${sessions.length} sessions for user ${userId}`);

    res.json({
      success: true,
      sessions,
      count: sessions.length
    });

  } catch (error) {
    console.error('Error fetching history:', error);
    
    res.status(500).json({ 
      error: 'Failed to fetch session history',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error',
      sessions: []
    });
  }
};