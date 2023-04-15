import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class BarChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Color(0xffF5FAFF),
        height: double.infinity,
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
          children: [
         Container(
           padding: EdgeInsets.only(left: 20,right: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height *0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:[Color(0xFF00A58D),Color(0xFF80BC4F)],
                        ),
          borderRadius: BorderRadius.only(
                         
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )
        ),
       child:Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.030,),
                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Icon(Icons.notifications_none,color: Color(0xFFE9EBEE),size:  MediaQuery.of(context).size.height*0.030,),
                    ],),                     Text("تمتع بانجازات جديدة", textAlign:TextAlign.right,style: TextStyle(color: Colors.white, fontSize:  MediaQuery.of(context).size.height*0.015,fontFamily: "odin-next-lt-w23" ),),
])),
               Container(
                 decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.white,Colors.white],
          ),
          borderRadius: BorderRadius.circular(20)
        ),
                      //color: Colors.white,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.09,left:  MediaQuery.of(context).size.height*0.012,right:  MediaQuery.of(context).size.height*0.012),
                      padding: EdgeInsets.only(left:  MediaQuery.of(context).size.height*0.012,right:  MediaQuery.of(context).size.height*0.012),
                      height: MediaQuery.of(context).size.height *0.5,
                 child:Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
               Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ 
               Icon(
  Icons.arrow_back_ios_outlined,color: Color(0xFFD4DAE3),),Icon(
  Icons.arrow_forward_ios_outlined,
color: Color(0xFFD4DAE3),),]),
                Text("الاسبوع الحالي", textAlign:TextAlign.right,style: TextStyle(fontFamily: "odin-next-lt-w23",color: Color(0xFF5D7B92), fontSize:  MediaQuery.of(context).size.height*0.030 ),),]),
                SizedBox(height: MediaQuery.of(context).size.height*0.020,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.height*0.050),
                      child:
                     
                Text("$total", textAlign:TextAlign.right,style: TextStyle(fontFamily: "odin-next-lt-w23",color:Color(0xFF5D7B92), fontSize:  MediaQuery.of(context).size.height*0.050 ),),),
                //SizedBox(height: 20,),
                Container(
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.01),
                      child:Text("مهمة", textAlign:TextAlign.right,style: TextStyle(fontFamily: "odin-next-lt-w23",color: Color(0xFFD4DAE3), fontSize:  MediaQuery.of(context).size.height*0.030 ),),)]),
                 BarChartSample3Statee(),
            ],
              )  
        ),]),
        SizedBox(height:  MediaQuery.of(context).size.height*0.030,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.white,Colors.white],
          ),
          borderRadius: BorderRadius.circular(20)

        ),
          height:MediaQuery.of(context).size.height*0.31,
          width: MediaQuery.of(context).size.width*0.47 ,
           margin: EdgeInsets.only(left:  MediaQuery.of(context).size.height*0.010),
           child:Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
              
           PieChart2State(color1:Color(0xffFBD9E7),color2:Color(0xffFC5794),dane: done,notdane: notdane,),
           ],)
        ),Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        Colors.white,Colors.white],
          ),
          borderRadius: BorderRadius.circular(20)

        ),
          height:MediaQuery.of(context).size.height*0.31,
          width: MediaQuery.of(context).size.width*0.47 ,
          margin: EdgeInsets.only(right:  MediaQuery.of(context).size.height*0.010),
           child:Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
              
           PieChart2State(color1:Color(0xffD8F6FF),color2:Color(0xff3DACF6),dane: notdane,notdane: done,),
           ],)
          
        )]),
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



  double satrday=0;
 double sunday=0;double monday=0;double tusday=0;double weday=0;double thusday=0;double friday=0;


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
        maxY: 30,


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
                  "السبت",
                  ),
                );
              case 1:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الاحد",
                  ),
                );
                case 2:
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      "الاثنين",
                    ),
                  );
                  case 3:
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    "الثلاثاء",
                  ),
                );
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
            BarChartRodData(toY: satrday, color:  Color(0xFFE9EBEE),width:20)
          
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: sunday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: monday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(toY: tusday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(toY: weday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(toY: thusday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(toY: friday, color: Color(0xFFE9EBEE),width:20)
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}



class BarChartSample3Statee extends StatelessWidget {
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
