
import 'package:flutter/material.dart';

class AppBarBuilder {
  static Widget commonAppBar(String title) {
    return AppBar(
      title: Text('$title'),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ), 
    );
  }
}