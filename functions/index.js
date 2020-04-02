const functions = require('firebase-functions');
const admin = require('firebase-admin');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const newFeedRequest = functions.firestore
    .document('feeds/{feedId}/requests/{userId}')
    .onCreate(async snapshot => {

        const feed = snapshot.data();

        const querySnapshot = await db
            .collection('users')
            .doc(feed.ownerId)
            .get();

        console.log('Found user token', querySnapshot);

        const payload = {
            notification: {
                title: `Du har en ny förfrågan från "${feed.name}"`,
                body: feed.comment,
                badge: '1',
                sound: 'default'
            }
        }

        admin
            .messaging()
            .sendToDevice(querySnapshot.token, payload)
            .then(response => {
                console.log('Succcessfully sent feed request', response)
            })
            .catch(error => {
                console.log('Error ', error)
            })

    });