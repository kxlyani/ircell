import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:ircell/providers/mobility_request_provider.dart';
import 'package:ircell/screens/page2/qr_view_example.dart';

class InternationalStudentsPage extends StatefulWidget {
  const InternationalStudentsPage({super.key});

  @override
  State<InternationalStudentsPage> createState() =>
      _InternationalStudentsPageState();
}

class _InternationalStudentsPageState extends State<InternationalStudentsPage> {
  final user = Auth().currentUser;
  String? uid;
  List<InboundInternship> internships = [];
  bool isLoading = true;
  String? errorMessage;
  List<MobilityRequest> mobilityRequests = [];
  bool isMobilityLoading = false;

  @override
  void initState() {
    super.initState();
    uid = user?.uid;
    _loadInternships();
    _loadMobilityRequests();
  }

  Future<void> _loadInternships() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedInternships = await fetchAllInboundInternships();

      setState(() {
        internships = fetchedInternships;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load internships: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.blueGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.textPrimary(context),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'International Students',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(
                        color: AppTheme.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _loadInternships,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Inbound Internships Section
                          _buildInboundInternshipsSection(),
                          const SizedBox(height: 32),
                          // Mobility Section
                          _buildMobilitySection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInboundInternshipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Inbound Internships',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        if (errorMessage != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loadInternships,
                  child: Text('Retry'),
                ),
              ],
            ),
          )
        else if (isLoading)
          SizedBox(
            height: 250,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading internships...',
                    style: TextStyle(color: AppTheme.textSecondary(context)),
                  ),
                ],
              ),
            ),
          )
        else if (internships.isEmpty)
          Container(
            height: 250,
            width: double.infinity,
            decoration: AppTheme.cardDecoration(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: AppTheme.textSecondary(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Internships Found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You don\'t have any inbound internships yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadInternships,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                ),
                // const SizedBox(height: 5),
              ],
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: internships.length,
              itemBuilder: (context, index) {
                final internship = internships[index];
                return _buildInternshipCard(internship);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildInternshipCard(InboundInternship internship) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: AppTheme.cardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showInternshipDetails(internship),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            internship.status == 'Active'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        internship.status,
                        style: TextStyle(
                          color:
                              internship.status == 'Active'
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  internship.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        internship.university,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      internship.country,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      internship.duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  internship.topic,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Campus Mobility',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showRequestMobilityDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Request'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          'Exit permissions require approval from both IR Faculty and Hostel Warden',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary(context),
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 16),

        if (isMobilityLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (mobilityRequests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: AppTheme.cardDecoration(context),
            child: Column(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 48,
                  color: AppTheme.textSecondary(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'No mobility requests yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Request permission to leave campus',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mobilityRequests.length,
            itemBuilder: (context, index) {
              final request = mobilityRequests[index];
              return _buildMobilityRequestCard(request);
            },
          ),
      ],
    );
  }

  Widget _buildMobilityRequestCard(MobilityRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.destination,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(request.status),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary(context),
                ),
                const SizedBox(width: 4),
                Text(
                  '${request.dateTime.day}/${request.dateTime.month}/${request.dateTime.year} at ${request.dateTime.hour}:${request.dateTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              'Purpose: ${request.purpose}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary(context),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _buildApprovalStatus(
                  'IR Faculty',
                  request.facultyApproval,
                  request.facultyApprovedAt,
                ),
                const SizedBox(width: 16),
                _buildApprovalStatus(
                  'Hostel Warden',
                  request.wardenApproval,
                  request.wardenApprovedAt,
                ),
              ],
            ),

            if (request.status == 'faculty_approved')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton.icon(
                  onPressed: () => _showQRCodeDialog(),
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: const Text('Get Warden Approval'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      case 'faculty_approved':
        color = Colors.blue;
        text = 'Faculty Approved';
        break;
      case 'fully_approved':
        color = Colors.green;
        text = 'Approved';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'Rejected';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(
    String approver,
    bool approved,
    DateTime? approvedAt,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              approved
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: approved ? Colors.green : Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  approved ? Icons.check_circle : Icons.pending,
                  size: 16,
                  color: approved ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    approver,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: approved ? Colors.green[700] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            if (approved && approvedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Approved ${_formatTime(approvedAt)}',
                  style: TextStyle(fontSize: 10, color: Colors.green[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showInternshipDetails(InboundInternship internship) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          internship.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildDetailRow('University', internship.university),
                        _buildDetailRow('Country', internship.country),
                        _buildDetailRow('Topic', internship.topic),
                        _buildDetailRow('Duration', internship.duration),
                        _buildDetailRow('Coordinator', internship.coordinator),

                        const SizedBox(height: 24),

                        Text(
                          'Description',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          internship.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary(context),
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (internship.announcements.isNotEmpty) ...[
                          Text(
                            'Announcements',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...internship.announcements
                              .map(
                                (announcement) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.announcement,
                                        size: 16,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          announcement,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: AppTheme.textPrimary(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ] else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary(
                                context,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppTheme.textSecondary(context),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'No announcements yet',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestMobilityDialog() {
    final destinationController = TextEditingController();
    final purposeController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.cardColor(context),
              title: Text(
                'Request Campus Exit',
                style: TextStyle(color: AppTheme.textPrimary(context)),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        hintText: 'Where are you going?',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose',
                        hintText: 'Why are you going?',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Date & Time',
                        style: TextStyle(color: AppTheme.textPrimary(context)),
                      ),
                      subtitle: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedTime.format(context)}',
                        style: TextStyle(
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                        color: AppTheme.textSecondary(context),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setDialogState(() {
                              selectedDate = date;
                              selectedTime = time;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textPrimary(context)),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => _submitMobilityRequest(
                        context,
                        destinationController.text,
                        purposeController.text,
                        selectedDate,
                        selectedTime,
                      ),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitMobilityRequest(
    BuildContext dialogContext,
    String destination,
    String purpose,
    DateTime selectedDate,
    TimeOfDay selectedTime,
  ) async {
    if (destination.isEmpty || purpose.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentUser = Auth().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Combine selected date and time
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Create the request data
      final requestData = {
        'student_id': currentUser.uid,
        'destination': destination.trim(),
        'purpose': purpose.trim(),
        'date_time': Timestamp.fromDate(selectedDateTime),
        'status': 'pending',
        'faculty_approval': false,
        'warden_approval': false,
        'faculty_approved_at': null,
        'warden_approved_at': null,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };

      // THIS IS THE KEY PART - Actually write to Firestore
      await FirebaseFirestore.instance
          .collection('student_mobility')
          .add(requestData);

      // Close the dialog
      Navigator.pop(dialogContext);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mobility request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the mobility requests list
      await _loadMobilityRequests();
    } catch (e) {
      print('Error submitting mobility request: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadMobilityRequests() async {
    final currentUser = Auth().currentUser;
    if (currentUser == null) return;

    try {
      setState(() {
        isMobilityLoading = true;
      });

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('student_mobility')
              .where('student_id', isEqualTo: currentUser.uid)
              .get();

      List<MobilityRequest> requests =
          querySnapshot.docs.map((doc) {
            final data = doc.data();

            return MobilityRequest(
              id: doc.id,
              destination: data['destination'] ?? '',
              purpose: data['purpose'] ?? '',
              dateTime:
                  (data['date_time'] as Timestamp?)?.toDate() ?? DateTime.now(),
              status: data['status'] ?? 'pending',
              // Use camelCase field names (the actual data in Firestore)
              facultyApproval: _convertToBoolean(data['facultyApproval']),
              wardenApproval: _convertToBoolean(data['warden_approval']),
              facultyApprovedAt: _convertToDateTime(data['facultyApprovedAt']),
              wardenApprovedAt: _convertToDateTime(data['warden_approved_at']),
            );
          }).toList();

      requests.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      setState(() {
        mobilityRequests = requests;
        isMobilityLoading = false;
      });
    } catch (e) {
      setState(() {
        isMobilityLoading = false;
      });
      print('Error loading mobility requests: $e');
    }
  }

  // Helper method to safely convert to boolean
  bool _convertToBoolean(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }

  // Helper method to safely convert to DateTime
  DateTime? _convertToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  void _showQRCodeDialog() {
    // This should be a unique code that only wardens have access to
    const wardenQRCode = "hostel_student_access_authorize";

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor(context),
            title: Text(
              'Warden Approval',
              style: TextStyle(color: AppTheme.textPrimary(context)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Scan the warden\'s QR code to get approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code'),
                  onPressed: () async {
                    Navigator.pop(context); // Close the current dialog
                    await _scanQRCodeForApproval(wardenQRCode);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _scanQRCodeForApproval(String expectedQRCode) async {
    final currentContext = context;
    final currentRequest = mobilityRequests.firstWhere(
      (req) => req.status == 'faculty_approved',
    );

    try {
      final qrCode = await Navigator.push<String>(
        currentContext,
        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
      );

      if (qrCode == expectedQRCode) {
        // Update Firestore with warden approval
        await FirebaseFirestore.instance
            .collection('student_mobility')
            .doc(currentRequest.id)
            .update({
              'warden_approval': true,
              'warden_approved_at': FieldValue.serverTimestamp(),
              'status': 'fully_approved',
            });

        // Refresh the list
        await _loadMobilityRequests();

        if (currentContext.mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Warden approval successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(
            content: Text('Invalid QR code. Please scan the warden\'s code.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
