class Checker {
  static int checkSites(List<List<dynamic>> data) {
    int index = 0;
    for (var line in data) {
      index++;
      line.removeWhere((elm) => elm.toString().isEmpty);
      if (line.length != 4) {
        return index;
      }
      try {
        int.parse(line[2].toString());
      } catch (_) {
        return index;
      }
    }
    return 0;
  }

  static int checkArticle(List<List<dynamic>> data) {
    int index = 0;
    for (var line in data) {
      index++;
      if (line.length != 11) {
        return index;
      }
      try {
        int.parse(line[1].toString());
      } catch (_) {
        return index;
      }
    }
    return 0;
  }

  static int checkProcess(List<List<dynamic>> data) {
    int index = 0;
    for (var line in data) {
      index++;
      if (line.length != 1) {
        return index;
      }
    }
    return 0;
  }
}
