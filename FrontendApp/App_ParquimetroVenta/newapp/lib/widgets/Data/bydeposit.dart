class SumarizacionEfectivo {
  final int status;
  final List<Datum> data;
  final String message;

  SumarizacionEfectivo({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SumarizacionEfectivo.fromJson(Map<String, dynamic> json) =>
      SumarizacionEfectivo(
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
  final int totalCash;
  final String type;

  Datum({
    required this.totalCash,
    required this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalCash: json["total_cash"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "total_cash": totalCash,
        "type": type,
      };
}
