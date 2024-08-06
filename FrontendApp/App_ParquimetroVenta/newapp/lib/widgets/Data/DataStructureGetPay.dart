class GetPay {
  final int status;
  final Getpay data;
  final String message;

  GetPay({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetPay.fromJson(Map<String, dynamic> json) => GetPay(
        status: json["status"],
        data: Getpay.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Getpay {
  final int money;
  final String description;

  Getpay({
    required this.money,
    required this.description,
  });

  factory Getpay.fromJson(Map<String, dynamic> json) => Getpay(
        money: json["money"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
        "description": description,
      };
}
