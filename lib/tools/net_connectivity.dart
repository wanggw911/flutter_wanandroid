import 'package:connectivity/connectivity.dart';

/* 
iOS 端使用的还是 Reachability 库来实现网络状态的监听
*/
class NetConnectivity {
  static NetConnectivity shared;

  ConnectivityResult currentResult;
  var subscription;

  void startListen() {
    //开始监听网络状态
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('网络状态发生改变：${result.toString()}');
      currentResult = result;
    });
  }

  void stopListen() {
    //取消监听网络状态
    subscription.cancel();
  }

  void getOriginConnectivityResult() async {
    currentResult = await (Connectivity().checkConnectivity());
    print('网络状态初始状态：${currentResult.toString()}');
  }

  void getWifiIP() async {
    var wifiIP = await (Connectivity().getWifiIP());
    print('wifiIP=$wifiIP');
  }

}