import 'dart:convert';

class RouterTools {

  /// object 转为 string json
  static String object2string<T>(T t) {
    return stringEncode(jsonEncode(t));
  }

  /// fluro 传递后取出参数，解析
  static String paramsDecode(String encodeCn) {
    var list = List<int>();
    ///字符串解码
    jsonDecode(encodeCn).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  /// 字符串转成map
  static Map<String, dynamic> string2map(String str) {
    return json.decode(paramsDecode(str));
  }

  /// 主要是对中文进行转码
  static String stringEncode(String value) {
    return jsonEncode(Utf8Encoder().convert(value));
  }

  /// string 转为 int
  static int string2int(String str) {
    return int.parse(str);
  }

  /// string 转为 double
  static double string2double(String str) {
    return double.parse(str);
  }

  /// string 转为 bool
  static bool string2bool(String str) {
    return str == 'true' ? true : false;
  }
}