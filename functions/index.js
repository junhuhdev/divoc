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

exports.completedFeedDelivery = functions
    .region('europe-west1')
    .firestore
    .document('feeds/{feedId}')
    .onUpdate((snapshot, context) => {
        console.log('----------------start function--------------------');

        const feed = snapshot.data();
        console.log('found updated feed request', feed);

        if (feed.status != "completed") {
            console.log('Feed is not completed yet do nothing...', feed);
            return null;
        }

        admin
            .firestore()
            .collection('users')
            .doc(feed.ownerId)
            .get()
            .then(querySnapShot => {
                console.log('Found user token', querySnapShot.data());

                const payload = {
                    notification: {
                        title: `${feed.name} har nu levererat dina varor.`,
                        body: feed.deliveredComment,
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


//exports.recursiveDelete = functions
//    .runWith({
//        timeoutSeconds: 540,
//        memory: '2GB'
//    })
//    .https.onCall((data, context) => {
//        // Only allow admin users to execute this function.
//        if (!(context.auth && context.auth.token && context.auth.token.admin)) {
//            throw new functions.https.HttpsError(
//                'permission-denied',
//                'Must be an administrative user to initiate delete.'
//            );
//        }
//
//        const path = data.path;
//        console.log(
//            `User ${context.auth.uid} has requested to delete path ${path}`
//        );
//
//        // Run a recursive delete on the given document or collection path.
//        // The 'token' must be set in the functions config, and can be generated
//        // at the command line by running 'firebase login:ci'.
//        return firebase_tools.firestore
//            .delete(path, {
//                project: process.env.GCLOUD_PROJECT,
//                recursive: true,
//                yes: true,
//                token: functions.config().fb.token
//            })
//            .then(() => {
//                return {
//                    path: path
//                };
//            });
//    });
