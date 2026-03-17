import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';

Widget alumniFloatingActionButton({
  required VoidCallback onPressed,
  required Icon icon,
  String tooltip = 'Alumni Action',
}) {
  final User? user = Auth().currentUser;

  if (user == null) {
    // If no user is logged in, hide the button
    return const SizedBox.shrink();
  }

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('alumni').doc(user.uid).get(),
    builder: (context, snapshot) {
      bool isAlumni = false;

      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData &&
          snapshot.data!.exists) {
        isAlumni = true;
      }

      return Visibility(
        visible: isAlumni,
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          child: icon,
        ),
      );
    },
  );
}
