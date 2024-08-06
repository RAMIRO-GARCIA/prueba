class Referencias {
  final int status;
  final List<Datum> data;
  final String message;

  Referencias({
    required this.status,
    required this.data,
    required this.message,
  });

  factory Referencias.fromJson(Map<String, dynamic> json) => Referencias(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  final int id;
  final String namebank;
  final String accountnumber;

  Datum({
    required this.id,
    required this.namebank,
    required this.accountnumber,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namebank: json["Namebank"],
        accountnumber: json["accountnumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Namebank": namebank,
        "accountnumber": accountnumber,
      };
}
