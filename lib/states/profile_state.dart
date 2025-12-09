
import 'app_state.dart';

class ProfileState extends AppState {

  bool followStatus = false;

  void setFollowStatus(bool type) {
    followStatus = type;
    notifyListeners();
  }

}