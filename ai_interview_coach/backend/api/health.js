// module.exports = (req, res) => {
//   const healthStatus = {
//     status: 'healthy',
//     timestamp: new Date().toISOString(),
//     uptime: process.uptime(),
//     memory: process.memoryUsage(),
//     environment: process.env.NODE_ENV || 'development',
//     version: '1.0.0',
//     services: {
//       openai: !!process.env.OPENAI_API_KEY,
//       firebase: !!process.env.FIREBASE_SERVICE_ACCOUNT
//     }
//   };

//   res.json(healthStatus);
// };

module.exports = (req, res) => {
  const healthStatus = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    services: {
      gemini: !!process.env.GEMINI_API_KEY,   // ✅ check Gemini instead of OpenAI
      firebase: !!process.env.FIREBASE_SERVICE_ACCOUNT
    }
  };

  res.json(healthStatus);
};
