/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin= require("firebase-admin");
const auth = require("firebase-auth");
var serviceAccount = require("./expiration-date-reminde-firebase-adminsdk-c6zmq-483a0e01cc.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.createCustomToken = onRequest(async(request, response) => {
    const user=request.body;

    const uid = 'kakao:${user.uid}';
    const updateParams ={ 
        email: user.email,
        photoURL:user.photoURL,
        displayName:user.displayName,

    };
    try{
        await admin.auth().updateUser(uid,updateParams);
    }catch (e){
        updateParams["uid"] = uid;

            await admin.auth().createUser(updateParams);
    }

  const token= await admin.auth().createCustomToken(uid);

    response.send(token);
});
