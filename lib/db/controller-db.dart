import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:sync_to_mongo/db/dbhelper.dart';
import 'package:sync_to_mongo/model/contato-model.dart';

class ControllerDb {
  final conn = DbHelper.instance;

  /// verifica se existe internet
  static Future<bool> isInternet() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet conneciton confirmed");
        return true;
      } else {
        print("Sem Internet : ( ....)");
        return false;
      }
    } else if (result == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print(" Wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print("No internet : ( ....)");
        return false;
      }
    }
    print("Nenhuma conexao foi detectada ");
    return false;
  }

  Future<int> addData(ContatoinfoModel contato) async {
    var dbClient = await conn.db;
    int result;
    try {
      result = await dbClient.insert(DbHelper.contatoTable, contato.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> updateData(ContatoinfoModel contato) async {
    var dbClient = await conn.db;
    int result;
    try {
      result = await dbClient.update(DbHelper.contatoTable, contato.toJson(),
          where: 'id=?', whereArgs: [contato.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchAll() async {
    var dbClient = await conn.db;
    List userList = [];
    try {
      List<Map<String, dynamic>> maps =
          await dbClient.query(DbHelper.contatoTable, orderBy: 'id DESC');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }
}
