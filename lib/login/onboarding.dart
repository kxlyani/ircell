import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/backend/firestore_service.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/screens/tabs_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key, required this.email, required this.password});
  final String email;
  final String password;
  @override
  State<Onboarding> createState() => _OnboardState();
}

class _OnboardState extends State<Onboarding> {
  late String email;
  late String password;
  final user_type = '';

  @override
  void initState() {
    super.initState();
    email = widget.email;
    password = widget.password;
  }

  int currentPage = 0;
  String userType = '';
  String externalCollegeType = '';
  List<String> selectedInterests = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController collegeNameController = TextEditingController();

  // International student fields
  final TextEditingController quotaController = TextEditingController();
  final TextEditingController admittedYearController = TextEditingController();
  final TextEditingController currentYearController = TextEditingController();
  final TextEditingController prnController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController parentsNameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController idDocumentController = TextEditingController();
  final TextEditingController passportNumberController =
      TextEditingController();
  final TextEditingController passportPhotoController = TextEditingController();

  // Alumni fields
  final TextEditingController passOutYearController = TextEditingController();
  final TextEditingController highestQualificationController =
      TextEditingController();
  final TextEditingController pgNameController = TextEditingController();
  final TextEditingController industryNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController stateNameController = TextEditingController();
  final TextEditingController countryNameController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  final PageController _pageController = PageController();

  // List of interest keywords
  final List<String> interestKeywords = [
    'Higher Studies',
    'IELTS',
    'GRE',
    'GMAT',
    'Internships',
    'IR Events',
    'Germany',
    'Japan',
    'USA',
    'Singapore',
    'Language Study',
    'German Language',
    'Japanese Language',
    'Career Guidance',
    'Scholarships',
    'Exchange Programs',
    'Research',
    'UK',
    'Australia',
    'Canada',
    'Technical Skills',
    'Cultural Exchange',
    'Networking',
    'Mentorship',
  ];

  void _nextPage() {
    if (_validateCurrentPage()) {
      if (currentPage < 2) {
        setState(() => currentPage++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  bool _validateCurrentPage() {
    if (currentPage == 0) {
      if (userType.isEmpty) {
        _showErrorDialog('Please select your user type to continue.');
        return false;
      }
      if (userType == 'external' && externalCollegeType.isEmpty) {
        _showErrorDialog('Please select your institute.');
        return false;
      }
      if (userType == 'external' &&
          externalCollegeType == 'Other' &&
          collegeNameController.text.isEmpty) {
        _showErrorDialog('Please enter your college name.');
        return false;
      }
      return true;
    } else if (currentPage == 1) {
      if (!_formKey.currentState!.validate()) {
        return false;
      }
      return true;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Input Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Widget _buildUserTypePage() {
    return ListView(
      children: [
        Text(
          "Tell us about yourself",
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Who are you?",
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.textSecondary(context),
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 10),
        _buildSelectableListTile("PCCOE Student", 'pccoe', Icons.school),
        _buildSelectableListTile(
          "International Student",
          'international',
          Icons.public,
        ),
        _buildSelectableListTile(
          "International Alumni",
          'alumni',
          Icons.emoji_events,
        ),
        _buildSelectableListTile(
          "External College Student",
          'external',
          Icons.account_balance,
        ),

        if (userType == 'external') ...[
          const SizedBox(height: 12),
          const Text(
            "Select your institute:",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: DropdownButton<String>(
              value: externalCollegeType.isEmpty ? null : externalCollegeType,
              hint: const Text("Select Institute"),
              isExpanded: true,
              underline: Container(),
              onChanged:
                  (value) => setState(() => externalCollegeType = value!),
              items:
                  ['PCCOE-R', 'PCU', 'Other']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
            ),
          ),
          if (externalCollegeType == 'Other') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: collegeNameController,
              decoration: InputDecoration(
                labelText: 'Enter college name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ],
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => _previousPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                backgroundColor: AppTheme.textSecondary(
                  context,
                ).withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Back",
                style: TextStyle(color: AppTheme.textPrimary(context)),
              ),
            ),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                backgroundColor: AppTheme.accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSelectableListTile(String title, String value, IconData icon) {
    final isSelected = userType == value;

    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppTheme.accentBlue : Colors.transparent,
          width: 2,
        ),
      ),
      color: AppTheme.cardColor(
        context,
      ), // Set card background to theme's dark color
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? AppTheme.textPrimary(context)
                    : AppTheme.textSecondary(context), // Explicit text colors
          ),
        ),
        leading: Icon(
          icon,
          color:
              isSelected
                  ? AppTheme.accentBlue
                  : AppTheme.textSecondary(context),
          size: 26,
        ),
        tileColor:
            isSelected
                ? AppTheme.accentBlue.withOpacity(0.1)
                : null, // Subtle selection highlight
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => setState(() => userType = value),
      ),
    );
  }

  Widget _buildDetailsFormPage() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const Text(
            "Personal Information",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 15),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Basic Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: firstNameController,
                    cursorColor: Colors.blueAccent,
                    decoration: _buildInputDecoration('First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameController,
                    cursorColor: Colors.blueAccent,
                    decoration: _buildInputDecoration('Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: contactController,
                    cursorColor: Colors.blueAccent,
                    decoration: _buildInputDecoration('Contact Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Specific fields based on user type
          if (userType == 'pccoe' || userType == 'external') ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Academic Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: deptController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Department'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your department';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: yearController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Year'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: rollController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('PRN'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your PRN';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ] else if (userType == 'international') ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "International Student Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: quotaController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Quota'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: admittedYearController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Admitted Academic Year',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: currentYearController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Current Year'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: prnController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('PRN Number'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: fullNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Full Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: parentsNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Parents Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: branchController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Branch'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Identity Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nationalityController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Nationality'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: genderController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Gender'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: idDocumentController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Identification Document',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passportNumberController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Passport/Citizenship No.',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passportPhotoController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Passport/Citizenship Photo URL',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (userType == 'alumni') ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alumni Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passOutYearController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Pass Out Year'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: branchController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Branch'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: highestQualificationController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Latest Highest Qualification',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: pgNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('PG Name'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Professional Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: industryNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Industry Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: designationController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Designation'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: stateNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('State Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: countryNameController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('Country Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: questionController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration(
                        'Why do you want to connect?',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: linkedinController,
                      cursorColor: Colors.blueAccent,
                      decoration: _buildInputDecoration('LinkedIn Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Back"),
              ),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Next"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInterestPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Interests",
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Choose topics that interest you most",
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.textSecondary(context),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  interestKeywords.map((interest) {
                    final isSelected = selectedInterests.contains(interest);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedInterests.remove(interest);
                          } else {
                            selectedInterests.add(interest);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.blue.shade700
                                  : AppTheme.primaryDarkBlue,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade300,
                          ),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary(context),
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Back"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate the form first
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) return;

                  _formKey.currentState!.save();

                  try {
                    // Register user in Firebase
                    await Auth().createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Then save form data to Firestore
                    _submitForm();

                    // Navigate after successful registration & Firestore write
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const TabsScreen(),
                      ),
                    );
                  } catch (e) {
                    _showErrorDialog('Registration failed: ${e.toString()}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      filled: true,
      fillColor: AppTheme.backgroundColor(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(fontSize: 18, color: AppTheme.textPrimary(context)),
        ),
        backgroundColor: AppTheme.cardColor(context), // Use theme-aware color
        iconTheme: IconThemeData(color: AppTheme.textPrimary(context)),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "${currentPage + 1} of 3",
                style: TextStyle(
                  color: AppTheme.textPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: AppTheme.backgroundColor(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildUserTypePage(),
                _buildDetailsFormPage(),
                _buildInterestPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showErrorDialog("User ID not found. Please try again.");
      return;
    }

    final firestoreService = FirestoreService();

    // Collect common data
    final commonData = {
      'email': email,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'contact': contactController.text,
      'interests': selectedInterests,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      if (userType == 'pccoe') {
        final data = {
          ...commonData,
          'roll_number': rollController.text,
          'department': deptController.text,
          'year': yearController.text,
        };
        await firestoreService.addPccoeStudent(uid, data);
      } else if (userType == 'international') {
        final data = {
          ...commonData,
          'prn': prnController.text,
          'quota': quotaController.text,
          'branch': branchController.text,
          'full_name': fullNameController.text,
          'parents_name': parentsNameController.text,
          'admitted_year': admittedYearController.text,
          'current_year': currentYearController.text,
          'gender': genderController.text,
          'nationality': nationalityController.text,
          'id_document': idDocumentController.text,
          'passport_number': passportNumberController.text,
          'passport_photo': passportPhotoController.text,
        };
        await firestoreService.addInternationalStudent(uid, data);
      } else if (userType == 'alumni') {
        final data = {
          ...commonData,
          'passout_year': passOutYearController.text,
          'qualification': highestQualificationController.text,
          'pg_name': pgNameController.text,
          'industry': industryNameController.text,
          'designation': designationController.text,
          'state': stateNameController.text,
          'country': countryNameController.text,
          'linkedin': linkedinController.text,
          'question_response': questionController.text,
          'isVerified': false,
        };
        await firestoreService.addAlumni(uid, data);
      } else if (userType == 'external') {
        final data = {
          ...commonData,
          'institute_type': externalCollegeType,
          'college_name': collegeNameController.text,
        };
        await firestoreService.addExternalCollegeStudent(uid, data);
      }

      // Navigate after successful submission
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const TabsScreen()),
      );
    } catch (e) {
      _showErrorDialog(
        'Something went wrong while saving your data. Please try again.\n\n$e',
      );
    }
  }
}