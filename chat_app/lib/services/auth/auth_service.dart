import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;




class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? getCurrentUser(){
    return _auth.currentUser;
  }
  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          'email': email,
          "name": displayName,
        },
      );
      
      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }
  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;
      if (kIsWeb) {
        // Sign-in for web
        //final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        //final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        googleUser = await _googleSignIn.signIn();
      } else {
        // Sign-in for iOS and Android
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        throw Exception('Google sign-in aborted by user');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      await _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': googleUser.displayName,
          
        },
        SetOptions(merge: true), // Merge data if the document already exists
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }
  
  //sign up
  Future<UserCredential>signUpWithEmailPassword(String email, String password, String displayName) async {
     try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

      await userCredential.user!.updateDisplayName(displayName);
      await userCredential.user!.reload();

      //save user info in a seperate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          'email': email,
          "name": displayName,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }
  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

}