import '../utils/db_helper.dart';

class UserDataModel {
  int? id;
  String? email;
  String? username;
  String? password;
  bool? isLoggedIn = false;

  UserDataModel({
    this.id,
    this.email,
    this.username,
    this.password,
    this.isLoggedIn
  });

  Future<bool?> getLoggedInStatus(String loggedInUsername) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> result = await DBHelper().query(
      'user_data',
      where: 'username = $username'
    );

    isLoggedIn = result[0]['loggedIn'] ?? result[0]['loggedIn'];
    return isLoggedIn;
  }

  Future<bool> checkUserLoggedIn(String username, String password) async {
    final List<Map<String, dynamic>> result = await DBHelper().query(
      'user_data', 
      where: 'username = "$username" AND password = "$password"'
    );

    if (result.isNotEmpty) {
      final bool isLoggedIn = result[0]['loggedIn'] == 1;
      return isLoggedIn;
    } else {
      return false;
    }
  }

  Future<void> dbSave() async {
    int isLoggedInValue = isLoggedIn != null && isLoggedIn == true ? 1 : 0;
    id = await DBHelper().insertData('user_data', {
      'email': email,
      'username': username,
      'password': password,
      'loggedIn': isLoggedInValue,
    });
  }

  Future<void> dbUpdate() async {
    await DBHelper().updateData('user_data', {
      'username': username,
    }, id!);
  }

}