import 'package:flutter/material.dart';

class AddInterestScreen extends StatefulWidget {
  final List<String> interestKeywords; // pass this
  final List<dynamic> existingInterests;

  const AddInterestScreen({
    super.key,
    required this.interestKeywords,
    required this.existingInterests,
  });

  @override
  State<AddInterestScreen> createState() => _AddInterestScreenState();
}

class _AddInterestScreenState extends State<AddInterestScreen> {
  late List<String> selectedInterests;

  @override
  void initState() {
    super.initState();
    selectedInterests = List<String>.from(widget.existingInterests);
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Interests"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedInterests);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.interestKeywords.map((interest) {
            final isSelected = selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (_) => _toggleInterest(interest),
              selectedColor: Colors.blue.shade700,
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ),
    );
  }
}
