import 'BaseNetwork.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();
  Future<Map<String, dynamic>> loadLeague() {
    return BaseNetwork.get("");
  }

  Future<Map<String, dynamic>> loadTeam(int idLeague) {
    return BaseNetwork.get("$idLeague");
  }

Future<Map<String, dynamic>> loadDetailTeam(int idLeague,int idTeam) {
    return BaseNetwork.get("$idLeague/$idTeam");
  }
}