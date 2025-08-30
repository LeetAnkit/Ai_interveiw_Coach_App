// backend/firebaseAdmin.js
// Initializes Firebase Admin SDK from FIREBASE_SERVICE_ACCOUNT env or ADC file path.
const admin = require('firebase-admin');

if (admin.apps.length === 0) {
  let creds = null;
  const svc = process.env.FIREBASE_SERVICE_ACCOUNT;
  if (svc) {
    try {
      creds = JSON.parse(svc);
    } catch (e) {
      console.error('Failed to parse FIREBASE_SERVICE_ACCOUNT JSON:', e.message);
    }
  }
  if (creds && creds.private_key && creds.client_email) {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: creds.project_id,
        clientEmail: creds.client_email,
        privateKey: creds.private_key.replace(/\\n/g, '\n'),
      }),
    });
    console.log('✅ Firebase Admin initialized from FIREBASE_SERVICE_ACCOUNT');
  } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
    });
    console.log('✅ Firebase Admin initialized from GOOGLE_APPLICATION_CREDENTIALS');
  } else {
    console.warn('⚠️ Firebase Admin not initialized — provide FIREBASE_SERVICE_ACCOUNT or GOOGLE_APPLICATION_CREDENTIALS');
  }
}

module.exports = admin;
