
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/model/home_article.dart';
import 'package:flutter_wanandroid/pages/common/web_detail_page.dart';
import 'package:flutter_wanandroid/tools/tools.dart';

class CommonListCell {
  static Widget articleCell(BuildContext context, dynamic model) {
    String _author;
    String _chanel;
    String _title;
    String _dateString;
    if (model is Article) {
      Article article = model;
      _author = article.author;
      _chanel = '${article.superChapterName}/${article.chapterName}';
      _title = article.title;
      _dateString = article.niceDate;
    }
  
    return Container(
      padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
      child: InkWell(
        onTap: () {
          //页面跳转：WebDetailPage 
          Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
              return WebDetailPage(model: model);
            })
          );
        },
        child: Card(
          child: Column(
            children: <Widget>[
              // Cell顶部栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.account_circle, size: 30, color: Colors.blue),
                        ),
                        Text('$_author'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '$_chanel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              // Cell标题栏
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                width: setWidth(710), // 750 - 20 - 20
                child: Text(
                  '$_title', 
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: setFontSize(34)),
                ),
              ),
              // Cell底部栏 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.favorite, size: 25, color: Colors.grey[400]),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(Icons.watch_later, size: 25, color: Colors.grey[400]),
                        ),
                        Text('$_dateString'),
                      ],
                    ),
                  ),
                  _cellTags(model),
                ],
              ),
            ],
          ),
      ),
      ),
    );
  }

  static Widget _cellTags(dynamic model) {
    List<Widget> tagWidgets = [];
    if (model is Article) {
      Article article = model;
      tagWidgets = _articleCellTags(article);
    }

    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: tagWidgets,
      )
    );
  }

  static List<Widget> _articleCellTags(Article article) {
    List<Widget> widgets = [];
    if (article.projectLink.length > 0) {
      //添加项目标签Widget
      widgets.add(Container(
                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Text('项目', style: TextStyle(color: Colors.red)),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.red)
                    ),
                  ));
    }
    if (article.fresh) {
      //添加新旧Widget
      widgets.add(Container(
                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Text('新', style: TextStyle(color: Colors.green)),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.green)
                    ),
                  ));
    }
    return widgets;
  }
}