const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

exports.getValueFromFirestore = functions.https.onRequest(
    (request, response) => {
      const documentRef = firestore.collection("users").doc("firstname");
      documentRef
          .get()
          .then((snapshot) => {
            if (snapshot.exists) {
              const data = snapshot.data();
              const value = data.fullname;
              response.send(`Value from Firestore: ${value}`);
            } else {
              response.status(404).send("Document not found");
            }
          })
          .catch((error) => {
            console.error("Error retrieving value from Firestore:", error);
            response.status(500).send("Error retrieving value from Firestore");
          });
    });
