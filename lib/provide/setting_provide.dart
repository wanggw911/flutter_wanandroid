
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/tools/save_to_location.dart';
import 'package:flutter_wanandroid/tools/theme_manage.dart';

enum SettingType {
  autoCache,
  noPictures,
  nighttime
}

class SettingProvide with ChangeNotifier {
  bool autoCache = true;
  bool noPictures = false;
  bool nighttime = false;

  ThemeData get themeData {
    //print('App初始化，夜间模式：${nighttime ? '开启' : '关闭'}');
    return nighttime ? kiOSDarkTheme : kiOSNormalTheme;
  } 

  void settingWith(SettingType type) {
    switch (type) {
      case SettingType.autoCache:
        autoCache = !autoCache;
        DataHander.saveBoolWith("autoCache", autoCache);
        print('设置，自动缓存：${autoCache ? '开启' : '关闭'}');
        break;
      case SettingType.noPictures:
        noPictures = !noPictures;
        DataHander.saveBoolWith("noPictures", noPictures);
        print('设置，无图模式：${noPictures ? '开启' : '关闭'}');
        break;
      case SettingType.nighttime:
        nighttime = !nighttime;
        DataHander.saveBoolWith("nighttime", nighttime);
        print('设置，夜间模式：${nighttime ? '开启' : '关闭'}');
        //themeData = nighttime ? kiOSDarkTheme : kiOSNormalTheme;
        break;
      default: // Without this, you see a WARNING.
        break;
    }

    notifyListeners();
  }

  Future readLocationSetting() async {
    bool _autoCache = await DataHander.readBoolWith("autoCache");
    if (_autoCache != null) {
      autoCache = _autoCache;
    }
    bool _noPictures = await DataHander.readBoolWith("noPictures");
    if (_noPictures != null) {
      noPictures = _noPictures;
    }
    bool _nighttime = await DataHander.readBoolWith("nighttime");
    if (_nighttime != null) {
      nighttime = _nighttime;
    }

    notifyListeners();
  }
}