class Distance {
  String text;
  int value;
  Distance({this.text, this.value});
  factory Distance.fromJson(dynamic json) {
    var dist = new Distance();
    try {
      dist = new Distance(
          text: json['text'] as String, value: json['value'] as int);
    } catch (e) {
      dist = new Distance(text: null, value: null);
    }
    return dist;
  }
}

class Duration {
  String text;
  int value;
  Duration({this.text, this.value});
  factory Duration.fromJson(dynamic json) {
    var dur = new Duration();
    try {
      dur = Duration(text: json['text'] as String, value: json['value'] as int);
    } catch (e) {
      dur = new Duration(text: "", value: 0);
    }
    return dur;
  }
}

class Element {
  Distance distance;
  Duration duration;
  String status;

  Element({this.distance, this.duration, this.status});
  factory Element.fromJson(dynamic json) {
    return Element(
        distance: Distance.fromJson(json['distance'] as dynamic),
        duration: Duration.fromJson(json['duration'] as dynamic),
        status: json['status'] as String);
  }
}

class GoogleRow {
  List<Element> elements = [];
  GoogleRow({this.elements});
  factory GoogleRow.fromJson(dynamic json) {
    var list = json['elements'] as List<dynamic>;
    return GoogleRow(elements: list.map((x) => Element.fromJson(x)).toList());
  }
}

class DistanceMatrix {
  List<String> destinationAdresses = [];
  List<String> originAdresses = [];
  List<GoogleRow> rows = [];
  String status;
  DistanceMatrix(
      {this.destinationAdresses, this.originAdresses, this.rows, this.status});

  factory DistanceMatrix.fromJson(dynamic json) {
    var rows = json['rows'] as List<dynamic>;
    var destination_addresses = json['destination_addresses'] as List<dynamic>;
    var origin_addresses = json['origin_addresses'] as List<dynamic>;
    return DistanceMatrix(
      destinationAdresses:
          destination_addresses.map((f) => f as String).toList(),
      originAdresses: origin_addresses.map((f) => f as String).toList(),
      rows: rows.map((f) => GoogleRow.fromJson(f)).toList(),
      status: json['status'] as String,
    );
  }
}

DistanceMatrix defaultDistanceMatrix = DistanceMatrix(
    destinationAdresses: [], originAdresses: [], rows: [], status: "");
