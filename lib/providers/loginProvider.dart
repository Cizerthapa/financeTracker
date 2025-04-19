import 'package:flutter/cupertino.dart';

class loginProvider with ChangeNotifier{
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String email, String password){
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout(){
    _isLoggedIn = false;
    notifyListeners();
  }
}