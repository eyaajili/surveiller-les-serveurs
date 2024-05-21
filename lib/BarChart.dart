import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: generateBarGroups(data),
        gridData: const FlGridData(show: true),
        alignment: BarChartAlignment.spaceAround,
        maxY: calculateMaxY(data),
      ),
    );
  }

  List<BarChartGroupData> generateBarGroups(List<Map<String, dynamic>> data) {
    final Map<String, int> nonOkCounts = {};

    data.forEach((document) {
      final nomDepartement = document['nom_departement'] as String;
      final countNonOk = document['count_nonok'] as int;
      nonOkCounts.putIfAbsent(nomDepartement, () => countNonOk);
    });

    return nonOkCounts.entries.map((entry) {
      final nomDepartement = entry.key;
      final countNonOk = entry.value;

      return BarChartGroupData(
        x: nonOkCounts.keys.toList().indexOf(nomDepartement),
        barRods: [
          BarChartRodData(
            toY: countNonOk.toDouble(),
            color: Colors.cyan, // Replace with your desired color
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  double calculateMaxY(List<Map<String, dynamic>> data) {
    final List<int> counts = data.map((document) => document['count_nonok'] as int).toList();
    return counts.isNotEmpty
        ? counts.reduce((a, b) => a > b ? a : b).toDouble()
        : 0;
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 2,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.cyan, // Replace with your desired color
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  FlTitlesData get titlesData {
    final List<String> departmentNames = data.map((item) => item['nom_departement'] as String).toList();

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final intValue = value.toInt();
            if (intValue >= 0 && intValue < departmentNames.length) {
              return Text(
                departmentNames[intValue],
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            } else {
              return SizedBox(); // Return an empty SizedBox if out of range
            }
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
    show: false,
  );
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3();

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  late Future<List<Map<String, dynamic>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Visite').get();

    // Map to store department-wise counts
    Map<String, int> departmentCounts = {};

    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      final nomDepartement = data['nom_departement'] as String;
      final verifications = (data['Vérification'] as List<dynamic>?) ?? [];

      // Count occurrences of 'etat' being 'nonok' for the specific 'nom_departement'
      int countNonOk = verifications
          .where((verification) => verification['etat'] == 'nonok' && verification['type'] != null)
          .length;

      // Update department-wise count
      departmentCounts[nomDepartement] = (departmentCounts[nomDepartement] ?? 0) + countNonOk;
    });

    // Convert department-wise counts to the required format
    List<Map<String, dynamic>> result = departmentCounts.entries.map((entry) {
      return {
        'nom_departement': entry.key,
        'count_nonok': entry.value,
      };
    }).toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }
        return AspectRatio(
          aspectRatio: 1.3,
          child: _BarChart(data: snapshot.data!),
        );
      },
    );
  }
}
