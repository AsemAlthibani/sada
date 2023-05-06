import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada/controller/task_report_controller.dart';
import 'package:sada/model/color_model.dart';
import 'package:sada/screen/small_screen/widget/most_accomplished_tasks.dart';

import '../widget/task_report_charts.dart';


class TaskReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskReportScreen();
}

class _TaskReportScreen extends State<TaskReportScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _asyncMethod();
  }
  double done=0;
  double notdane=0;
  var total=0;
  _asyncMethod() async {

  }
  List<int> selectedSpots = [];
  List<String> orderType =[
    "اليوم",
    "الأمس",
    "هذا الشهر",
    "الشهر السابق",
    "الكل",
   ];
  String orderTypeValue="اليوم";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TaskReportController taskReport = Provider.of<TaskReportController>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorsModel.ColorsMineLite,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "تقارير المهام",
            style: TextStyle(
                fontFamily: "TS-Safaa",
                color: ColorsModel.ColorsMineLite,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.w500
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
        width: double.infinity,
        color: Color(0xffF5FAFF),
        height: double.infinity,
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  color: ColorsModel.ColorsWhite
                ),
                //color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal:  size.height*0.012),
                padding: EdgeInsets.symmetric(horizontal:  size.height*0.012),
                height: size.height *0.5,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding:EdgeInsets.symmetric(vertical: size.height*0.01),child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    Text("حدد المدة", style: TextStyle(
                  fontFamily: "TS-Safaa",
                  color: Colors.black,
                  fontSize:  size
                      .width * 0.04,)),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorsModel.ColorsMineLite, width: 1.3)
                              ),
                              height: size.height * 0.05,
                              alignment: Alignment.center,
                              child: DropdownButton(
                                value: orderTypeValue,
                                underline: Container(),
                                borderRadius: BorderRadius.circular(20),
                                dropdownColor: Colors.white,
                                icon: const Icon(Icons.keyboard_arrow_down,
                                  color: ColorsModel.ColorsMineLite,),
                                alignment: Alignment.center,
                                items: orderType.map((String occasions) {
                                  return DropdownMenuItem<String>(
                                      value: occasions,
                                      child: Container(
                                          width: size.width * 0.2,
                                          alignment: Alignment.center,

                                          child: Text(occasions, style: TextStyle(
                                            fontFamily: "TS-Safaa",
                                            color: Colors.black,
                                            fontSize:  size
                                                .width * 0.04,))
                                      ));
                                }
                                ).toList(),
                                onChanged: (String? newValue) async{
                                  setState(() {
                                    orderTypeValue = newValue!;
                                  });
                                  if (orderTypeValue == "الكل") {
                                    var date1, date2;
                                    await taskReport.setReportData(true, date1, date2);
                                  } else {
                                    var startDate, endDate;
                                    var date = DateTime.now();
                                    if (orderTypeValue == "اليوم") {
                                      startDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month, date.day, 0, 0,
                                          0));
                                      endDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime.now());
                                    } else if (orderTypeValue == "الأمس") {
                                      startDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month, date.day - 1));
                                      endDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month, date.day - 1,
                                          23, 59, 60));
                                    } else if (orderTypeValue == "هذا الشهر") {
                                      startDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month, 1, 0, 0, 0));
                                      endDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month, date.day, 0, 0,
                                          0));
                                    } else
                                    if (orderTypeValue == "الشهر السابق") {
                                      startDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month - 1, 1, 0, 0,
                                          0));
                                      endDate = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss'Z'", 'en')
                                          .format(DateTime(
                                          date.year, date.month - 1,
                                          DateTime(date.year, date.month, 0)
                                              .day));
                                    }
                                    await taskReport.setReportData(false, startDate, endDate);
                                  }
                                },
                              )
                          ),
                        ]),),
                    TaskReportCharts(),

                  ],
                )
            ),
            SizedBox(height:  size.height*0.030,),
            MostAccomplishedTasks(),
          ])));
          
       
    
  }
}

class _BarChart extends StatefulWidget {
  @override
  BarCharts createState() => BarCharts();
  _BarChart({Key? key}) ;
}
class BarCharts extends State<_BarChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  initiali();
    _asyncMethod();
  }



  double satrday=59;
 double sunday=15;double monday=30;double tusday=20;double weday=0;double thusday=0;double friday=0;


  _asyncMethod() async {


    print(satrday);
  }



 // BuildContext get context => null;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,


      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: Color(0xFFD0D9DF),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          drawBehindEverything: true,
          sideTitles: SideTitles(
            getTitlesWidget:(double? value,TitleMeta meta) {
            switch (value!.toInt()) {
              case 0:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الاقسام",
                    style: TextStyle(
                        fontFamily: "TS-Safaa",
                        color: ColorsModel.ColorsMineLite,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                );
              case 1:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الاحد",
                    style: TextStyle(
                        fontFamily: "TS-Safaa",
                        color: ColorsModel.ColorsMineLite,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w500
                    ),
                  ),

                  angle: 10,
                );
                case 2:
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      "الاقسام",
                      style: TextStyle(
                          fontFamily: "TS-Safaa",
                          color: ColorsModel.ColorsMineLite,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500
                      ),
                    ),                  );
                  case 3:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الاقسام",
                    style: TextStyle(
                        fontFamily: "TS-Safaa",
                        color: ColorsModel.ColorsMineLite,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w500
                    ),
                  ),                );
                case 4:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الاربعاء",
                  ),
                );
                case 5:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الخميس",
                  ),
                );
                case 6:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الجمعة",
                  ),
                );
              case 7:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الجمعة",
                  ),
                );
              case 8:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الجمعة",
                  ),
                );
              case 9:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الجمعة",
                  ),
                );
                default:
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      "",
                    ),
                  );
            }
          }),
        ),
        leftTitles: AxisTitles(drawBehindEverything: false),
        topTitles: AxisTitles(drawBehindEverything: false),
        rightTitles: AxisTitles(drawBehindEverything: false),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => [

        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(toY: satrday, color:  ColorsModel.ColorsMineLite,width:20)
          
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: sunday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: monday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(toY: tusday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(toY: weday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(toY: thusday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(toY: friday, color: ColorsModel.ColorsMineLite,width:20)
          ],
          showingTooltipIndicators: [0],
        ),
    BarChartGroupData(
      x: 7,
      barRods: [
        BarChartRodData(toY: friday, color: ColorsModel.ColorsMineLite,width:20)
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 8,
      barRods: [
        BarChartRodData(toY: friday, color: ColorsModel.ColorsMineLite,width:20)
      ],
      showingTooltipIndicators: [0],
    ),
      ];
}



class TaskReportScreenStatee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Card(
        
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color:  Colors.white,
        
        child:  _BarChart(),
      ),
    );
  }
}  



class PieChart2State extends StatelessWidget{
  int touchedIndex = -1;
  Color? color1;
  Color? color2;
  double? dane=0;
  double? notdane=0;
PieChart2State({this.color1,this.color2,this.dane,this.notdane});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(color1!,color2!)),
                ),
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(Color color1,Color color2) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 30.0 : 16.0;
      final radius = isTouched ? 40.0 : 30.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: color1,
            value: dane,
            title: '',
            radius: radius,
           
          );
        case 1:
          return PieChartSectionData(
            color:  color2,
            value: notdane,
            title: "",
            radius: radius,
            
          );
        
        default:
          throw Error();
      }
    });
  }
}
