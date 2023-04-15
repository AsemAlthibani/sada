import 'package:fluttertoast/fluttertoast.dart';
import 'package:sada/model/color_model.dart';


class ToastModel{

  getToastModel(title)async{
      return Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 04,
        backgroundColor:ColorsModel.ColorsMineLite,
        textColor: ColorsModel.ColorsWhite,
      );
  }
}