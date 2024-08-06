class PaymentMoney {
    final int status;
    final Data data;
    final String message;

    PaymentMoney({
        required this.status,
        required this.data,
        required this.message,
    });

    factory PaymentMoney.fromJson(Map<String, dynamic> json) => PaymentMoney(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    final double money;

    Data({
        required this.money,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        money: json["money"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "money": money,
    };
}
