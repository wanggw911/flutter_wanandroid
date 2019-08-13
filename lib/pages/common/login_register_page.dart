
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_wanandroid/model/user.dart';
import 'package:flutter_wanandroid/provide/user_provide.dart';
import 'package:flutter_wanandroid/routers/navigator_tool.dart';
import 'package:flutter_wanandroid/tools/CustomTheme.dart';
import 'package:flutter_wanandroid/tools/save_to_location.dart';
import 'package:flutter_wanandroid/tools/uikit_help.dart';
import 'package:provide/provide.dart';

enum PageType {
  login,
  register,
}

class LoginRegisterPage extends StatefulWidget {
  final PageType pageType;
  LoginRegisterPage({Key key, this.pageType}) : super(key: key);

  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String title;
  List<Widget> rightActions = [];
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){ 
      _readLocationAccount();
    });
  
    switch (widget.pageType) {
      case PageType.login:
        title = "登录";
        rightActions = [
          FlatButton(
            child: Text('注册'),
            onPressed: () {
              NavigatorTool.push(context, LoginRegisterPage(pageType: PageType.register));
            },
          )
        ];
        break;
      case PageType.register:
        title = "注册";
        break;
      default: // Without this, you see a WARNING.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //设置状态栏文字为黑色
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    //设置整个状态栏的背景颜色
    //FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    //下面的设置都没有任何作用
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
        appBar: AppBar(
          //brightness: Brightness.dark,//设置状态栏为黑色
          backgroundColor: LoginPageTheme.navigationColor(context),
          elevation: 0, //去掉导航栏下面的阴影
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue,),
            onPressed: (){
              _hiddenKeyboard();
              Navigator.pop(context);
            },
          ),
          actions: rightActions,
        ),
        body: _content(),
      );
  }

  Widget _content() {
    return Provide<UserProvide>(builder: (context, child, value) {
      User user = Provide.value<UserProvide>(context).user;
      if (user != null) {
        //不能立即跳转，需要延时一下，否则就会黑屏一闪而过
        Future.delayed(Duration(seconds: 1), () {
          print('login success');
          Navigator.pop(context);
        });
      }
    
      return Container(
        //decoration: BoxDecoration(color: Colors.white),
        //添加点击手势收键盘
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _hiddenKeyboard();
          },
          child: Column(
            children: <Widget>[
              Container(
                height: setHeight(300),
                //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)), //use for debug frame
                child: Center(
                  child: Text('$title', style: TextStyle(fontSize: setFontSize(60)),),
                ),
              ),
              _inputContent("User Name", Icon(Icons.account_circle), _userNameTextController),
              _inputContent("Password", Icon(Icons.security), _passwordTextController),
              _buttonContent(),
            ],
          ),
        ),
      );
    });
  }

  Widget _inputContent(String placeholder, Icon icon, TextEditingController controller) {
    return Container(
      width: setWidth(550),
      height: setHeight(80),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[200])),
      ), 
      child: Center(
        child: TextFormField(
          controller: controller,
          //focusNode: ,
          onEditingComplete: () {
            
          },
          decoration: InputDecoration(
            //icon: icon,
            prefixIcon: icon,
            hintText: "$placeholder",
            border: InputBorder.none
            //border: InputBorder(borderSide: BorderSide(width: 1, color: ))
          ),
          style: TextStyle(
            fontSize: setFontSize(30), 
            color: LoginPageTheme.inputTextColor(context),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "Email can not be empty";
            }
            return "";
          },
        ),
      ),
    );
  }

  Widget _buttonContent() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: setWidth(550),
        height: setHeight(80),
        child: RaisedButton(
          color: Colors.blue,
          child: Text('$title', style: TextStyle(color: Colors.white, fontSize: setFontSize(30)),),
          onPressed: () {
            _hiddenKeyboard();
            _submitAction();
          },
        ),
      ),
    );
  }

  void _hiddenKeyboard() {
    // 触摸收起键盘
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _readLocationAccount() {
    setState(() {
      _userNameTextController.text = DataHander.readStringWith("username");
      _passwordTextController.text = DataHander.readStringWith("password");
    });
  }

  void _submitAction() {
    //登录、注册提交
    switch (widget.pageType) {
      case PageType.login:
        login();
        break;
      case PageType.register:
        register();
        break;
      default: // Without this, you see a WARNING.
        break;
    }
  }

  Future login() async {
    var username = _userNameTextController.text;
    var password = _passwordTextController.text;
    await Provide.value<UserProvide>(context).login(username, password);
  }

  Future register() async {
    var username = _userNameTextController.text;
    var password = _passwordTextController.text;
    await Provide.value<UserProvide>(context).register(username, password);
  }
}