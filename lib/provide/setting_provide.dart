
import 'package:flutter/material.dart';

enum SettingType {
  autoCache,
  noPictures,
  nighttime
}

class SettingProvide with ChangeNotifier {
  bool autoCache = true;
  bool noPictures = false;
  bool nighttime = false;
  
  void settingWith(SettingType type) {
    switch (type) {
      case SettingType.autoCache:
        autoCache = !autoCache;
        print('设置，自动缓存：${autoCache ? '开启' : '关闭'}');
        break;
      case SettingType.noPictures:
        noPictures = !noPictures;
        print('设置，无图模式：${noPictures ? '开启' : '关闭'}');
        break;
      case SettingType.nighttime:
        nighttime = !nighttime;
        print('设置，夜间模式：${nighttime ? '开启' : '关闭'}');
        break;
      default: // Without this, you see a WARNING.
        break;
    }

    notifyListeners();
  }
}