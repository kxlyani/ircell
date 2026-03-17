import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

Future<void> sendEmailsToAllUsers(Map<String, dynamic> eventDetails) async {
  final smtpServer = gmail('Your Email address', 'App Password');
  List<String> allEmails = [];

  try {
    final pccoeDocs = await FirebaseFirestore.instance.collection('pccoe_students').get();
    final intlDocs = await FirebaseFirestore.instance.collection('international_students').get();
    final extlDocs = await FirebaseFirestore.instance.collection('external_college_students').get();

    allEmails.addAll(pccoeDocs.docs.map((doc) => doc['email'] as String));
    allEmails.addAll(intlDocs.docs.map((doc) => doc['email'] as String));
    allEmails.addAll(extlDocs.docs.map((doc) => doc['email'] as String));

    allEmails = allEmails.toSet().toList(); // Remove duplicates

    final message = Message()
      ..from = Address('Your Email address', 'PCCOE Events')
      ..recipients.addAll(allEmails)
      ..subject = '📢 New Event: ${eventDetails['title']}'
      ..html = '''
      <h2>${eventDetails['title']}</h2>
      <p><strong>Date:</strong> ${eventDetails['date']}</p>
      <p><strong>Time:</strong> ${eventDetails['time']}</p>
      <p><strong>Location:</strong> ${eventDetails['location']}</p>
      <p><strong>Speaker:</strong> ${eventDetails['speaker']}</p>
      <p>${eventDetails['description']}</p>
      <img src="${eventDetails['imageURL']}" style="max-width:100%;"/>
      ''';

    await send(message, smtpServer);
    print('✅ Email sent to all users!');
  } catch (e) {
    print('❌ Failed to send email: $e');
  }
}
