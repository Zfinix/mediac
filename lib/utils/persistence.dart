import 'dart:convert';
import 'package:mediac/views/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

///-------------PROFILE DATA----------------///
saveProfileData({var profileData}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('Saved Profile Data');
  prefs.setString('profileData', json.encode(profileData.toJson()));
}

/* saveLoginData({LoginModel loginData}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  prefs.setBool('firstTime' , false);
  print('Saved Login Data');

  prefs.setString('loginData', json.encode(loginData.toJson()));
} */

eraseProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('Erased Profile Data');
  prefs.remove('loginData');
  prefs.remove('hmoProfileData');
  prefs.remove('providerProfileData');
}

/* Future<GetProfileData> getProfileData(String userRole) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  LoginModel loginData;
  var profileData;

  print('Fetch Profile Data');

  if (userRole == 'hmo') {
    profileData = HMOProfileModel.fromJson(
        json.decode(prefs.getString('hmoProfileData')));

    loginData = LoginModel.fromJson(json.decode(prefs.getString('loginData')));
  } else {
    profileData = HMOProfileModel.fromJson(
        json.decode(prefs.getString('providerProfileData')));

    loginData = LoginModel.fromJson(json.decode(prefs.getString('loginData')));
  }
  return new GetProfileData(loginData: loginData, profileData: profileData);
}
 */
saveItem({item, key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('Saved New $key Data');
  await prefs.setString('$key', item);
}

eraseItem({key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('Erased $key  Data');
  prefs.remove('$key');
}

eraseItems({List<String> keys}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  for (var i = 0; i < keys.length; i++) {
    print('Erased ${keys[i]} Data');
    prefs.remove('${keys[i]}');
  }
}

Future<Notify> loadNotifItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data;
  try {
      print(prefs.getString('notifs'));
    if (prefs.getString('notifs') != null)
      data = Notify.fromJson(json.decode(prefs.getString('notifs')));
      
    else
      return null;
  } catch (e) {
    print(e.toString());
  }

  print('loaded Notifs');
  return data;
}

saveNotifItems({Notify notifs}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(notifs.toJson());
    prefs.setString('notifs', json.encode(notifs.toJson()));
    print('saved Notifs');
  } catch (e) {
    print(e.toString());
  }
}

eraseAll() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<dynamic> getItemData({key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.get('$key');
}

/* class GetProfileData {
  final profileData;
  final LoginModel loginData;

  GetProfileData({@required this.profileData, @required this.loginData});
} */
