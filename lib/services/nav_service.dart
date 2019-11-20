import 'package:scoped_model/scoped_model.dart';

mixin NavService on Model {
  int _currentIndex = 0;
  String _currentPath = '/home';

  int getCuttentIndex() {
    return _currentIndex;
  }

  String getCurrentPath() {
    return _currentPath;
  }
}
