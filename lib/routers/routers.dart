
// import 'package:fluro/fluro.dart';

class Router {
  static Router router;

  static String root = '/';
  static String detailsPage = '/detail';
  
  // static void configureRouters(Router router) {
  //   router.notFoundHandler = Handler(
  //     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //       print('ERROR ===> ROUTER $context $params');
  //       return NotFountPage(params: params);
  //     }
  //   );

  //   router.define(detailsPage, handler: detailsHandler);
  // }

}