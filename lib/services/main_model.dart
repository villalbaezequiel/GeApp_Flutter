import 'package:scoped_model/scoped_model.dart';

import 'friend_service.dart';
import 'me_service.dart';

class MainModel extends Model with MeService, FriendService {}
