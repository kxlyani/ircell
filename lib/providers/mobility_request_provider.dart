import 'package:cloud_firestore/cloud_firestore.dart';

class MobilityRequest {
  final String id;
  final String destination;
  final String purpose;
  final DateTime dateTime;
  final bool facultyApproval;
  final bool wardenApproval;
  final String status;
  final DateTime? facultyApprovedAt;
  final DateTime? wardenApprovedAt;

  MobilityRequest({
    required this.id,
    required this.destination,
    required this.dateTime,
    required this.purpose,
    required this.status,
    required this.facultyApproval,
    required this.wardenApproval,
    this.facultyApprovedAt,
    this.wardenApprovedAt,
  });

  factory MobilityRequest.fromMap(Map<String, dynamic> map, String id) {
    return MobilityRequest(
      id: id,
      destination: map['destination'] as String,
      purpose: map['purpose'] as String,
      dateTime: (map['date_time'] as Timestamp).toDate(),
      facultyApproval: map['faculty_approval'] as bool,
      wardenApproval: map['warden_approval'] as bool,
      status: map['status'] as String,
      facultyApprovedAt:
          map['faculty_approved_at'] != null
              ? (map['faculty_approved_at'] as Timestamp).toDate()
              : null,
      wardenApprovedAt:
          map['warden_approved_at'] != null
              ? (map['warden_approved_at'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'dateTime': Timestamp.fromDate(dateTime),
      'purpose': purpose,
      'status': status,
      'facultyApproval': facultyApproval,
      'wardenApproval': wardenApproval,
      'facultyApprovedAt':
          facultyApprovedAt != null
              ? Timestamp.fromDate(facultyApprovedAt!)
              : null,
      'wardenApprovedAt':
          wardenApprovedAt != null
              ? Timestamp.fromDate(wardenApprovedAt!)
              : null,
    };
  }
}
