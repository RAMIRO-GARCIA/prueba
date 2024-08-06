//Estructura para mostrar efectivo para depositar
class CardBydeposit {
  final int status;
  final List<Datum> data;
  final String message;

  CardBydeposit({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CardBydeposit.fromJson(Map<String, dynamic> json) => CardBydeposit(
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
  final int moneyAmount;
  final String moneyType;

  Datum({
    required this.moneyAmount,
    required this.moneyType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        moneyAmount: json["money_amount"]?.toDouble() ?? 0.0,
        moneyType: json["money_type"],
      );

  Map<String, dynamic> toJson() => {
        "money_amount": moneyAmount,
        "money_type": moneyType,
      };
}
