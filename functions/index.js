const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info('Hello logs!', { structuredData: true });
  response.send('Hello from Firebase!');
});

exports.sendNotification = functions.firestore
  .document('images/{imageId}')
  .onCreate((snapshot, context) => {
    const imageUrl = snapshot.data().url;
    const title = snapshot.data().title;

    const payload = {
      notification: {
        title: 'New Quiz Added!',
        body: `${title} has been added.`,
      },
      data: {
        imageUrl: imageUrl,
      },
    };

    return admin.messaging().sendToTopic('newImage', payload);
  });
