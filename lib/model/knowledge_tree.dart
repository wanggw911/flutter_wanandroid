//接口地址：https://www.wanandroid.com/tree/json
class KnowledgeTreeNodeRespond {
  List<KnowledgeTreeNode> data;
  int errorCode;
  String errorMsg;

  KnowledgeTreeNodeRespond({this.data, this.errorCode, this.errorMsg});

  KnowledgeTreeNodeRespond.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<KnowledgeTreeNode>();
      json['data'].forEach((v) {
        data.add(new KnowledgeTreeNode.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class KnowledgeTreeNode {
  List<KnowledgeTreeNode> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;
  String subNodeNames; //额外添加的属性，用来显示子Node名称拼接出来的字符串

  KnowledgeTreeNode(
      {this.children,
      this.courseId,
      this.id,
      this.name,
      this.order,
      this.parentChapterId,
      this.userControlSetTop,
      this.visible});

  KnowledgeTreeNode.fromJson(Map<String, dynamic> json) {
    subNodeNames = "";
    if (json['children'] != null) {
      children = new List<KnowledgeTreeNode>();
      bool isFirst = true;
      json['children'].forEach((v) {
        KnowledgeTreeNode node = KnowledgeTreeNode.fromJson(v);
        children.add(node);
        if (isFirst) {
          subNodeNames += node.name;
          isFirst = false;
        }
        else {
          subNodeNames += "、${node.name}";
        }
      });
    }
    courseId = json['courseId'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    parentChapterId = json['parentChapterId'];
    userControlSetTop = json['userControlSetTop'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['courseId'] = this.courseId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['parentChapterId'] = this.parentChapterId;
    data['userControlSetTop'] = this.userControlSetTop;
    data['visible'] = this.visible;
    return data;
  }
}