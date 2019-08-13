import 'dart:convert'; // 提供 string to json 的方法
import 'package:http/http.dart' as http; // 第三方网络请求

class Engine {

  static Future<EngineCallBack> get(url, {Map<String, String> headers, Map<String, String> params}) async {
    var requestUrl = url;
    requestUrl += paramsString(params);

    var client = http.Client();
    http.Response response = await client.get(requestUrl, headers: headers);
    
    return responseHander(response);
  }

  static Future post(url, {Map<String, String> headers, Map<String, String> params}) async {
    var requestUrl = url;
    
    var client = http.Client();
    http.Response response = await client.post(requestUrl, headers: headers, body: params);
    
    return responseHander(response);
  }  

  static EngineCallBack responseHander(http.Response response) {
    var url = response.request.url;
    
    //【异常判断1】：请求状态码的判断
    if (response.statusCode != 200) {
      String errorInfo = "接口请求错误，错误码" + response.statusCode.toString();
      print("❌请求失败，错误信息：$errorInfo\n\turl=$url");
      return EngineCallBack(null, errorInfo);
    }

    //【异常判断2】：errorCode，错误回调
    var jsonMap = json.decode(response.body);
    if ((jsonMap['errorCode'] as int) < 0) {
      String errorInfo = jsonMap['errorMsg'] as String;
      print("❌请求失败，错误信息：$errorInfo\n\turl=$url");
      return EngineCallBack(null, errorInfo);
    }

    print("✅请求成功，url=$url");
    dynamic data = jsonMap['data'];
    return EngineCallBack(data, null);
  }

  static String paramsString(Map<String, String> params) {
    String paramsString = "";
    if (params != null && params.isNotEmpty) {
      paramsString += "?";
      params.forEach((key, value) {
        paramsString += "$key=$value&";
      });
      paramsString = paramsString.substring(0, paramsString.length-1);
    }
    return paramsString;
  }
}

class EngineCallBack {
  dynamic data;
  String errorInfo;

  EngineCallBack(this.data, this.errorInfo);
}