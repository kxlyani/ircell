import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: AppTheme.glassDecoration(context),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppTheme.textPrimary(context),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text(
              'About Us',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 48), // Balance the row
          ],
        ),
      ),
      backgroundColor: AppTheme.backgroundColor(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with IR image
              _buildHeaderSection(context),

              const SizedBox(height: 24),

              // About IR Section
              _buildSectionCard(
                context: context,
                title: 'About IR',
                child: _buildAboutIRContent(context),
              ),

              const SizedBox(height: 20),

              // IR Coordinators Section
              _buildSectionCard(
                context: context,
                title: 'IR Coordinators',
                child: _buildCoordinatorsContent(context),
              ),

              const SizedBox(height: 20),

              // Partnerships Section
              _buildSectionCard(
                context: context,
                title: 'Partnerships',
                child: _buildPartnershipsContent(context),
              ),

              const SizedBox(height: 20),

              // Our Team Section
              _buildSectionCard(
                context: context,
                title: 'Our Team',
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction,
                        size: 48,
                        color: AppTheme.accentBlue.withOpacity(0.7),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We’re still putting the pieces together!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This section will be updated soon.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Developer Team Section
              _buildSectionCard(
                context: context,
                title: 'Our Developer Team',
                child: _buildTeamGrid(context, isVolunteers: false),
              ),

              const SizedBox(height: 20),

              // Contact Us Section
              _buildSectionCard(
                context: context,
                title: 'Contact Us',
                child: _buildContactUsContent(context),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double imageSize = screenSize.width * 0.3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // IR Logo Image with glass decoration
        Container(
          width: imageSize,
          height: imageSize,
          decoration: AppTheme.glassDecoration(
            context,
          ).copyWith(borderRadius: BorderRadius.circular(imageSize / 2)),
          child: ClipOval(
            child: Image.asset(
              'assets/images/ircircle.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business,
                    size: imageSize * 0.4,
                    color: AppTheme.textPrimary(context),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Header Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'International',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              Text(
                'Relations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              Text(
                'Cell',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with underline
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.accentBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAboutIRContent(BuildContext context) {
    return Text(
      'At the International Relations Cell, we are engaged in increasing global outreach by promoting the academic and research exchange for students and faculty of PCCOE and its international partners. The International Relations Office maintains and sustains Memorandums of Understanding (MoUs) with various international universities and organisations which are active in strengthening the global academic and research exchanges.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        height: 1.6,
        color: AppTheme.textPrimary(context),
      ),
    );
  }

  Widget _buildCoordinatorsContent(BuildContext context) {
    const coordinators = [
      {
        'name': 'Dr. Roshani Raut',
        'position': 'Dean of International Relations',
        'department': 'IR',
        'image': 'assets/coordinator1.jpg',
      },
    ];

    return Column(
      children:
          coordinators.map((coordinator) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardColor(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accentBlue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        coordinator['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.accentBlue.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              color: AppTheme.textPrimary(context),
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coordinator['name']!,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coordinator['position']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary(context),
                          ),
                        ),
                        Text(
                          coordinator['department']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPartnershipsContent(BuildContext context) {
    const partners = [
      'RWTH Aachen University',
      'PETRONAS University',
      'LSI R&D lab, Japan',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Valued Partners',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        ...partners.map((partner) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.business, size: 20, color: AppTheme.accentBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    partner,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTeamGrid(BuildContext context, {required bool isVolunteers}) {
    final teamMembers =
        isVolunteers
            ? [
              {
                'name': 'Volunteer 1',
                'role': 'Team Leader',
                'image': 'assets/dev1.jpg',
              },
              {
                'name': 'Volunteer 2',
                'role': 'Event Management',
                'image': 'assets/dev2.jpg',
              },
            ]
            : [
              {
                'name': 'Adway Aghor',
                'role': 'Team Leader',
                'image': 'assets/dev1.jpg',
              },
              {
                'name': 'Kalyani Patil',
                'role': 'Flutter Developer',
                'image': 'assets/dev2.jpg',
              },
              {
                'name': 'Atharv Rao',
                'role': 'Backend & Flutter Developer',
                'image': 'assets/dev3.jpg',
              },
              {
                'name': 'Tanushka Patil',
                'role': 'Flutter Developer',
                'image': 'assets/dev4.jpg',
              },
              {
                'name': 'Aditya Bhosale',
                'role': 'ML & Data Science',
                'image': 'assets/dev4.jpg',
              },
            ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teamMembers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final member = teamMembers[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.cardColor(context).withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentBlue.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    member['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.accentBlue.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: AppTheme.textPrimary(context),
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                member['name']!,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary(context),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                member['role']!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary(context),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactUsContent(BuildContext context) {
    return Column(
      children: [
        Text(
          'Get in Touch',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary(context),
          ),
        ),
        const SizedBox(height: 16),

        // Contact Information
        _buildContactItem(
          Icons.email,
          'Email',
          'contact@irplatform.com',
          context,
        ),
        const SizedBox(height: 12),
        _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-4567', context),
        const SizedBox(height: 12),
        _buildContactItem(
          Icons.location_on,
          'Address',
          '123 Financial District,\nNew York, NY 10005',
          context,
        ),

        const SizedBox(height: 20),

        // Social Media
        Text(
          'Follow Us',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.facebook, context),
            const SizedBox(width: 16),
            _buildSocialIcon(Icons.camera_alt, context),
            const SizedBox(width: 16),
            _buildSocialIcon(Icons.link, context),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.accentBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary(context),
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
      ),
      child: Icon(icon, color: AppTheme.accentBlue, size: 20),
    );
  }
}
