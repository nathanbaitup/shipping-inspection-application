import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class QuestionnaireHub extends StatefulWidget {
  const QuestionnaireHub({Key? key}) : super(key: key);

  @override
  _QuestionnaireHubState createState() => _QuestionnaireHubState();
}

class _QuestionnaireHubState extends State<QuestionnaireHub> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData("F&S Yes", 2, Color.fromRGBO(0, 200, 0, 1)),
      ChartData("F&S No", 1, Color.fromRGBO(200, 0, 0, 1)),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Questionnaire Hub",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Table(
                  children: [
                    const TableRow(
                      children: [
                        Text(
                          "Sections",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Progress",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Questionnaire Link",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Fire & Safety",
                          textScaleFactor: 1.5,
                        ),
                        Expanded(
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              // Renders doughnut chart
                              DoughnutSeries<ChartData, String>(
                                dataSource: chartData,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
                                startAngle: 270, // Starting angle of doughnut
                                endAngle: 90,
                              ) // Ending angle of doughnut),
                            ],
                          ),
                        ),
                        const ElevatedButton(
                          onPressed: null,
                          child: const Text("Go to the Section?"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
