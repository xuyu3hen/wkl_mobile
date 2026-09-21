import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget gmAvatar(String url, {
  double width = 30,
  double? height,
  BoxFit? fit,
  BorderRadius? borderRadius,
}) {
  var placeholder = Image.asset(
      "imgs/avatar-default.png", //头像占位图
      width: width,
      height: height
  );
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>placeholder,
      errorWidget: (context, url, error) =>placeholder,
    ),
  );
}

void showToast(String text, {
  gravity = ToastGravity.CENTER,
  toastLength = Toast.LENGTH_SHORT,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[600],
    fontSize: 16.0,
  );
}

void showLoading(context, [String? text]) {
  String text1 = text ?? "Loading...";
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
                boxShadow: [
                  //阴影
                  BoxShadow(
                    color: Colors.black12,
                    //offset: Offset(2.0,2.0),
                    blurRadius: 10.0,
                  )
                ]),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(minHeight: 120, minWidth: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    text1,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

// 获取格式化后的purchaseNum字符串
String formattedNum(double num) {
  if (num == num.toInt()) {
    return num.toInt().toString();
  } else {
    return num.toString();
  }
}

// 校验日期格式是否正确
bool isValidDateFormat(String dateString) {
  // 正则表达式匹配yyyy-mm-dd格式
  final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  
  // 首先检查格式是否匹配
  if (!dateRegex.hasMatch(dateString)) {
    return false;
  }
  
  // 尝试解析日期
  try {
    List<String> parts = dateString.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    
    // 检查月份是否有效
    if (month < 1 || month > 12) {
      return false;
    }
    
    // 检查日期是否有效
    int daysInMonth;
    if (month == 2) {
      // 闰年判断
      bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      daysInMonth = isLeapYear ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(month)) {
      daysInMonth = 30;
    } else {
      daysInMonth = 31;
    }
    
    if (day < 1 || day > daysInMonth) {
      return false;
    }
    
    return true;
  } catch (e) {
    return false;
  }
}