import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ircell/providers/alumni_provider.dart';
import 'package:ircell/screens/activities/alumni_details.dart';

class AlumniScreen extends StatefulWidget {
  const AlumniScreen({Key? key}) : super(key: key);

  @override
  State<AlumniScreen> createState() => _AlumniScreenState();
}

class _AlumniScreenState extends State<AlumniScreen> {
  List<Alumni> _allAlumni = [];
  List<Alumni> _filteredAlumni = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;

  Future<void> fetchAlumni() async {
  print('[DEBUG] fetchAlumni() called');

  setState(() => _isLoading = true);

  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('alumni').get();

    print('[DEBUG] Documents fetched: ${snapshot.docs.length}');

    final alumniList = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('[DEBUG] Alumni document: $data');
      return Alumni.fromMap(data);
    }).toList();

    setState(() {
      _allAlumni = alumniList;
      _filteredAlumni = alumniList;
      _isLoading = false;
    });

    print('[DEBUG] Alumni list initialized: ${_allAlumni.length} members');

  } catch (e) {
    print('[ERROR] Failed to fetch alumni: $e');
    setState(() => _isLoading = false);
  }
}


  void _filterAlumni(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered =
        _allAlumni.where((alumni) {
          return alumni.firstName.toLowerCase().contains(lowerQuery) ||
              alumni.lastName.toLowerCase().contains(lowerQuery) ||
              alumni.country.toLowerCase().contains(lowerQuery) ||
              alumni.state.toLowerCase().contains(lowerQuery) ||
              alumni.pgName.toLowerCase().contains(lowerQuery);
        }).toList();

    setState(() {
      _filteredAlumni = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAlumni();
    _searchController.addListener(() {
      final query = _searchController.text;
      if (query.isEmpty) {
        setState(() {
          _filteredAlumni = _allAlumni;
        });
      } else {
        _filterAlumni(query);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _filteredAlumni.isEmpty
              ? Center(child: Text('No matching alumni found'))
              : ListView.builder(
                itemCount: _filteredAlumni.length,
                padding: const EdgeInsets.all(12.0),
                itemBuilder: (context, index) {
                  final alumni = _filteredAlumni[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlumniDetailScreen(alumni: alumni),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${alumni.firstName} ${alumni.lastName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              alumni.designation.isNotEmpty
                                  ? '${alumni.designation} at ${alumni.industry}'
                                  : alumni.industry,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 6),
                            Text('PG: ${alumni.pgName}'),
                            Text('Passout: ${alumni.passoutYear}'),
                            Text(
                              'Location: ${alumni.state}, ${alumni.country}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
