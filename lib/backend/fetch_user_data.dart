import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ircell/backend/shared_pref.dart';

Future<Map<String, dynamic>?> fetchUserDetails() async {
  final uid = await LocalStorage.getUID();

  if (uid == null) {
    print('No UID found in local storage');
    return null;
  }

  final List<String> collections = [
    'pccoe_students',
    'international_students',
    'external_students',
    'alumni'
  ];

  for (final collection in collections) {
    final docSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      return {
        'uid' : uid,
        'first_name': data?['first_name'],
        'last_name': data?['last_name'],
        'email': data?['email'],
        'contact': data?['contact'],
        'department': data?['department'],
        'interests': List<String>.from(data?['interests'] ?? []),
        'year': data?['year'],
        'source_collection': collection, // optional: where the record was found
      };
    }
  }

  print('User not found in any collection');
  return null;
}

Future<Map<String, dynamic>?> fetchUserDetailsForEditing() async {
  final uid = await LocalStorage.getUID();
  if (uid == null) return null;

  final collections = [
    'pccoe_students',
    'international_students',
    'external_students',
    'alumni'
  ];

  for (final collection in collections) {
    final doc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if (doc.exists) {
      return {
        'uid': uid,
        'collection': collection,
        'data': doc.data(), // All fields for that user
      };
    }
  }

  return null;
}

Future<Map<String, dynamic>?> fetchUserInfo(String coll, String uid) async {
  try {
    final docSnapshot = await FirebaseFirestore.instance.collection(coll).doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      return {
        'first_name': data['first_name'] ?? '',
        'last_name': data['last_name'] ?? '',
        'email': data['email'] ?? '',
      };
    }
    return null; // user document does not exist
  } catch (e) {
    print('Error fetching user info: $e');
    return null;
  }
}

Future<String?> getUserCollectionForStream() async {
  final uid = await LocalStorage.getUID();
  if (uid == null) return null;

  final collections = [
    'pccoe_students',
    'international_students',
    'external_students',
    'alumni'
  ];

  for (final collection in collections) {
    final doc = await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    if (doc.exists) {
      return collection;
    }
  }

  return null;
}
