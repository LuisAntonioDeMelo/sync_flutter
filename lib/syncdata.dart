import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:sync_to_mongo/db/dbhelper.dart';
import 'package:sync_to_mongo/model/contato-model.dart';

class SyncData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print('mobile data detect is possible to sinck');
        return true;
      } else {
        print('No internet : ( ...)');
      }
    }
    if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print(' wifi data detect & internet connection confirmed');
        return true;
      } else {
        print('No internet : (R ....) ');
        return false;
      }
    } else {
      print(
          'Neither mobile data or WIFI detected, not internet connection found ');
      return false;
    }
  }

  final conn = DbHelper.instance;

  Future<List<ContatoinfoModel>> fetchAllinfo() async {
    final dbClient = await conn.db;
    List<ContatoinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(DbHelper.contatoTable);
      for (var item in maps) {
        contactList.add(ContatoinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }
}
