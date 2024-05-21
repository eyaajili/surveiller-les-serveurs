import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData, required this.monthlyVisitsData});

  final bool isShowingMainData;
  final Map<String, int> monthlyVisitsData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 {
    double maxYValue;

    if (monthlyVisitsData.values.isNotEmpty) {
      maxYValue = monthlyVisitsData.values.reduce((value, element) => value > element ? value : element).toDouble() + 1;
    } else {
      // Handle the empty data scenario appropriately
      // For example, set maxYValue to a default value
      maxYValue = 1.0; // or any other appropriate default value
    }

    return LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: monthlyVisitsData.length.toDouble() - 1,
      maxY: maxYValue,
      minY: 0,
    );
  }


  LineChartData get sampleData2 {
    if (monthlyVisitsData.isEmpty) {
      return LineChartData(); // Return empty data if monthlyVisitsData is empty
    }

    return LineChartData(
      lineTouchData: lineTouchData2,
      gridData: gridData,
      titlesData: titlesData2,
      borderData: borderData,
      lineBarsData: lineBarsData2,
      minX: 0,
      maxX: monthlyVisitsData.length.toDouble() - 1,
      maxY: monthlyVisitsData.values.reduce((value, element) => value > element ? value : element).toDouble() + 1,
      minY: 0,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_1,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text('${value.toInt()}', style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (monthlyVisitsData.isEmpty) {
      return SizedBox(); // If data is empty, return an empty widget
    }

    final monthIndex = value.toInt();
    final sortedMonths = monthlyVisitsData.keys.toList()..sort((a, b) => a.compareTo(b));
    if (monthIndex < sortedMonths.length) {
      final month = sortedMonths[monthIndex];
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      );
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(month, style: style),
      );
    } else {
      return SizedBox(); // If the index exceeds the number of months, return an empty widget
    }
  }



  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.grey.withOpacity(0.8), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.green.shade50,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: true),
    spots: monthlyVisitsData.entries
        .map((entry) => FlSpot(monthlyVisitsData.keys.toList().indexOf(entry.key).toDouble(), entry.value.toDouble()))
        .toList(),
  );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,
    curveSmoothness:0,
    color: Colors.blue.withOpacity(0.9),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: true),
    spots: monthlyVisitsData.entries
        .map((entry) => FlSpot(monthlyVisitsData.keys.toList().indexOf(entry.key).toDouble(), entry.value.toDouble()))
        .toList(),
  );
}

class LineChartSample1 extends StatefulWidget {
  final String selectedDepartment; // Add selected department parameter

  const LineChartSample1({Key? key, required this.selectedDepartment}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  late Map<String, int> monthlyVisitsData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    monthlyVisitsData = {}; // Initialize empty data
    fetchMonthlyVisits();
  }

  @override
  void didUpdateWidget(covariant LineChartSample1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update chart data when selected department changes
    if (widget.selectedDepartment != oldWidget.selectedDepartment) {
      fetchMonthlyVisits();
    }
  }

  Future<void> fetchMonthlyVisits() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Visite')
          .orderBy('Date', descending: false)
          .get();

      monthlyVisitsData = {};

      querySnapshot.docs.forEach((doc) {
        String departmentName = doc['nom_departement'] as String;
        if (departmentName == widget.selectedDepartment || widget.selectedDepartment == 'All') {
          Timestamp visitTimestamp = doc['Date'] as Timestamp;
          DateTime visitDate = visitTimestamp.toDate();

          // Format the month name using DateFormat
          String monthName = DateFormat.MMMM().format(visitDate);

          if (monthlyVisitsData.containsKey(monthName)) {
            monthlyVisitsData[monthName] = monthlyVisitsData[monthName]! + 1;
          } else {
            monthlyVisitsData[monthName] = 1;
          }
        }
      });

      // Print the fetched data
      print('Monthly Visits Data:');
      monthlyVisitsData.forEach((month, visits) {
        print('$month: $visits');
      });

      setState(() {});
    } catch (e) {
      // Handle errors
      print('Error fetching data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Nombre de visite par mois',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(isShowingMainData: isShowingMainData, monthlyVisitsData: monthlyVisitsData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.blueAccent.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
