import 'package:scoped_model/scoped_model.dart';

import 'me_service.dart';
import 'nav_service.dart';

class MainModel extends Model with NavService, MeService {}
