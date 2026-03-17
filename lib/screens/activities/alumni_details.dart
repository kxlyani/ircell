import 'package:flutter/material.dart';
import 'package:ircell/providers/alumni_provider.dart';

class AlumniDetailScreen extends StatelessWidget {
  final Alumni alumni;

  const AlumniDetailScreen({Key? key, required this.alumni}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${alumni.firstName} ${alumni.lastName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DetailRow(title: 'Email', value: alumni.email),
            DetailRow(title: 'Contact', value: alumni.contact),
            DetailRow(title: 'Designation', value: alumni.designation),
            DetailRow(title: 'Industry', value: alumni.industry),
            DetailRow(title: 'PG Name', value: alumni.pgName),
            DetailRow(title: 'Qualification', value: alumni.qualification),
            DetailRow(title: 'Passout Year', value: alumni.passoutYear),
            DetailRow(title: 'State', value: alumni.state),
            DetailRow(title: 'Country', value: alumni.country),
            DetailRow(title: 'LinkedIn', value: alumni.linkedin),
            DetailRow(title: 'Interests', value: alumni.interests.join(', ')),
            DetailRow(title: 'Outbound Programs', value: alumni.outbound.join(', ')),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text('$title:', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
