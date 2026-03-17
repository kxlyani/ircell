import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPccoeStudent(String uid, Map<String, dynamic> data) async {
    await _db.collection('pccoe_students').doc(uid).set(data);
  }

  Future<void> addInternationalStudent(String uid, Map<String, dynamic> data) async {
    await _db.collection('international_students').doc(uid).set(data);
  }

  Future<void> addAlumni(String uid, Map<String, dynamic> data) async {
    await _db.collection('alumni').doc(uid).set(data);
  }

  Future<void> addExternalCollegeStudent(String uid, Map<String, dynamic> data) async {
    await _db.collection('external_college_students').doc(uid).set(data);
  }
}