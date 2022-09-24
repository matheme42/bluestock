abstract class Serializable {
  Map<String, dynamic> asMap();

  void fromMap(Map<String, dynamic> data);
}

class Model extends Serializable {
  int? id;

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey('id') ? id = data['id'] : 0;
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};

    message['id'] = id;
    return message;
  }
}
