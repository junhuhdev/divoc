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


exports.newFeedRequest = functions
    .region('europe-west1')
    .firestore
    .document('feeds/{feedId}/requests/{userId}')
    .onCreate((snapshot, context) => {
        console.log('----------------start function--------------------');

        const feed = snapshot.data();
        console.log('found new feed request', feed);

        admin
            .firestore()
            .collection('users')
            .doc(feed.ownerId)
            .get()
            .then(querySnapShot => {
                console.log('Found user token', querySnapShot.data());

                const payload = {
                    notification: {
                        title: `Du har en ny förfrågan från ${feed.name}`,
                        body: feed.comment,
                        badge: '1',
                        sound: 'default'
                    }
                }

                admin
                    .messaging()
                    .sendToDevice(querySnapShot.data().token, payload)
                    .then(response => {
                        console.log('Succcessfully sent feed request', response)
                    })
                    .catch(error => {
                        console.log('Error ', error)
                    })

            })

        return null;

    });