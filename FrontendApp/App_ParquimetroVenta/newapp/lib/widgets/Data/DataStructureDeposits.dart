class DepositAll {
    final int status;
    final Data data;
    final String message;

    DepositAll({
        required this.status,
        required this.data,
        required this.message,
    });

    factory DepositAll.fromJson(Map<String, dynamic> json) => DepositAll(
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
    final double totalCash;

    Data({
        required this.totalCash,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCash: json["total_cash"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "total_cash": totalCash,
    };
}
