import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/model/color_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../controller/task_report_controller.dart';

List<UsersAgeData> femaleData =[];

List<UsersAgeData> maleData =[];

class TaskReportCharts extends StatelessWidget {
  const TaskReportCharts({Key? key}) : super(key: key);

  BarSeries<UsersAgeData, String> _createBarSeries(
      List<UsersAgeData> dataSource,
      ) {
    return BarSeries<UsersAgeData, String>(
      spacing: 0.25,
      width: 0.9,
      trackBorderWidth: 0,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
      enableTooltip: true,
      isVisibleInLegend:true,
      isVisible: true,
      dataSource: dataSource,
      xAxisName: "lsaas",
      yAxisName: "asassa",
      xValueMapper: (UsersAgeData data, _) => data.age,
      yValueMapper: (UsersAgeData data, _) => data.percent,
      dataLabelMapper: (UsersAgeData data, _) => data.name,
      dataLabelSettings: DataLabelSettings(isVisible: true,color: Colors.red),
      markerSettings: MarkerSettings(isVisible: true,color: Colors.red),
      emptyPointSettings: EmptyPointSettings(color: Colors.red),


    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isorientation= MediaQuery.of(context).orientation == Orientation.landscape;
    TaskReportController taskReportController=Provider.of<TaskReportController>(context, listen: true);
    return Container(
      width: isorientation?size.width*0.6:size.width,
      height: size.height*0.42,
      padding: const EdgeInsets.only(left: 0),
      child: SfCartesianChart(
        crosshairBehavior: CrosshairBehavior(
            activationMode:ActivationMode.doubleTap
        ),isTransposed: true,
        legend: Legend(
            orientation: LegendItemOrientation.vertical,
            alignment:ChartAlignment.center),
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          text: "مهام الموظفين",
          textStyle: TextStyle(color: ColorsModel.ColorsMineLite),
          alignment: ChartAlignment.far,
        ),
        primaryXAxis: CategoryAxis(
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
                details.text,
                TextStyle(color: ColorsModel.ColorsMineLite)
            );
          },
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          majorGridLines: const MajorGridLines(width: 0),
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel(
                '${details.text}',
                TextStyle(color: ColorsModel.ColorsMineLite)
            );
          },
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0, width: 0),
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: ColorsModel.ColorsMineLite,
          ),
          minorTickLines: const MinorTickLines(size: 0, width: 0),
          minorGridLines: const MinorGridLines(width: 0),
          maximum: taskReportController.highestTasks,
        ),
        palette: const <Color>[
          ColorsModel.ColorsMine,
          ColorsModel.ColorsMineLite,
        ],
        series: <ChartSeries>[
          _createBarSeries(femaleData),
          _createBarSeries(maleData),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}
class UsersAgeData {
  const UsersAgeData(this.age, this.percent,this.name);

  final String age;
  final double percent;
  final String name;

}
