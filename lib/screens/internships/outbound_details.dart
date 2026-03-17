import 'package:flutter/material.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:ircell/screens/page1.dart';

class OutboundDetails extends StatefulWidget {
  const OutboundDetails({super.key});

  @override
  OutboundDetailsState createState() => OutboundDetailsState();
}

class OutboundDetailsState extends State<OutboundDetails> {
  List<OutboundInternship> internships = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInternships();
  }

  Future<void> loadInternships() async {
    final fetched = await fetchAllOutboundInternships();
    setState(() {
      internships = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Outbound Internships")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: internships.length,
        itemBuilder: (context, index) {
          final internship = internships[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: buildInternshipCard(internship, screenSize, context),
          );
        },
      ),
    );
  }
}
