import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'Indicator.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, int> statistics;

  const PieChartWidget({Key? key, required this.statistics}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.statistics.entries.map((entry) {
              final isTouched =
                  widget.statistics.keys.toList().indexOf(entry.key) == touchedIndex;
              final fontSize = isTouched ? 25.0 : 16.0;
              final radius = isTouched ? 60.0 : 50.0;
              final color = _getColorForIndex(entry.key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      touchedIndex = touchedIndex == widget.statistics.keys.toList().indexOf(entry.key) ? -1 : widget.statistics.keys.toList().indexOf(entry.key);
                    });
                  },
                  child: Indicator(
                    color: color,
                    text: entry.key,
                    isSquare: true,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return widget.statistics.entries.map((entry) {
      final color = _getColorForIndex(entry.key);
      final isTouched =
          widget.statistics.keys.toList().indexOf(entry.key) == touchedIndex;
      final double initialRadius = 50;
      final double touchedRadius = 60;
      final double radius = isTouched ? touchedRadius : initialRadius;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.value.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );

    }).toList();
  }

  Color _getColorForIndex(String key) {
    // Generate distinct colors based on a predefined list
    List<Color> colorList = [
      Colors.blue.shade100,
      Colors.green.shade200,
      Colors.lime.shade200,
      Colors.red.shade200,
      Colors.teal.shade200,
      Colors.indigo.shade200,
      Colors.purple.shade50,
      Colors.pink.shade50,
      Colors.deepOrange.shade100,
      Colors.orange.shade100,
    ];
    // Use modulus to ensure index does not go out of bounds
    final index = widget.statistics.keys.toList().indexOf(key) % colorList.length;
    return colorList[index];
  }
}
