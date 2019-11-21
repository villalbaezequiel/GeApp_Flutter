import 'package:scoped_model/scoped_model.dart';

mixin NavService on Model {
  String _currentRoute = '/home';

  String get currentRoute => _currentRoute;

  setRouteAndIndex(String route) {
    _currentRoute = route;
    notifyListeners();
  }
}
