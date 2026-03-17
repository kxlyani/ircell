import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final List<String> exams = ['GRE', 'TOEFL', 'GATE'];
  String selectedExam = 'GRE';

  final Map<String, List<FlSpot>> examScores = {
    'GRE': [FlSpot(1, 295), FlSpot(2, 300), FlSpot(3, 308)],
    'TOEFL': [FlSpot(1, 90), FlSpot(2, 95), FlSpot(3, 100)],
    'GATE': [FlSpot(1, 35), FlSpot(2, 40), FlSpot(3, 45)],
  };

  final Map<String, Color> examColors = {
    'GRE': Colors.blue,
    'TOEFL': Colors.green,
    'GATE': Colors.deepOrange,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Activities'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Events Attended'),
              _eventList(),
        
              const SizedBox(height: 24),
              _sectionTitle('Certificates'),
              _certificateList(),
        
              const SizedBox(height: 24),
              _sectionTitle('Analytics'),
              _analyticsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _eventList() {
    final events = [
      'AI Conference 2023',
      'Flutter Forward India',
      'GATE Prep Webinar',
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: events
            .map((e) => ListTile(
                  leading: const Icon(Icons.event, color: Colors.indigo),
                  title: Text(e),
                ))
            .toList(),
      ),
    );
  }

  Widget _certificateList() {
    final certificates = [
      'Know Japan 24',
      'Explore Germany 24',
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: certificates
            .map((c) => ListTile(
                  leading: const Icon(Icons.verified, color: Colors.teal),
                  title: Text(c),
                ))
            .toList(),
      ),
    );
  }

  Widget _analyticsSection() {
  final points = examScores[selectedExam]!;
  final color = examColors[selectedExam]!;

  final double maxY = points.map((e) => e.y).reduce((a, b) => a > b ? a : b);
  final double minY = points.map((e) => e.y).reduce((a, b) => a < b ? a : b);

  double interval = ((maxY - minY) / 4).ceilToDouble();
  if (interval == 0) interval = 1;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exam Score Progression',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Dropdown for exam selection
          DropdownButtonFormField<String>(
            value: selectedExam,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            items: exams
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedExam = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                minY: minY - interval,
                maxY: maxY + interval,
                lineBarsData: [
                  _examLine(
                    title: selectedExam,
                    color: color,
                    points: points,
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(value.toInt().toString()),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) =>
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('T${value.toInt()}'),
                          ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'T1, T2, T3 = Different attempts or timelines',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

  LineChartBarData _examLine({
    required String title,
    required Color color,
    required List<FlSpot> points,
  }) {
    return LineChartBarData(
      spots: points,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.15),
      ),
    );
  }
}