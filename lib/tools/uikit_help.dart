import 'package:flutter_screenutil/flutter_screenutil.dart';

//封装 flutter_screenutil，提供更易用的API
double setWidth(double height) {
  return ScreenUtil().setWidth(height);
}

double setHeight(double height) {
  return ScreenUtil().setHeight(height);
}

double setFontSize(double fontSize) {
  return ScreenUtil().setSp(fontSize);
}