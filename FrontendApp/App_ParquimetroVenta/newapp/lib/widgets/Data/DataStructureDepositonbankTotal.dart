class DepositOnbankAll {
    final int status;
    final Data data;
    final String message;

    DepositOnbankAll({
        required this.status,
        required this.data,
        required this.message,
    });

    factory DepositOnbankAll.fromJson(Map<String, dynamic> json) => DepositOnbankAll(
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
    final double totalDeposit;

    Data({
        required this.totalDeposit,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalDeposit: json["total_deposit"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "total_deposit": totalDeposit,
    };
}
