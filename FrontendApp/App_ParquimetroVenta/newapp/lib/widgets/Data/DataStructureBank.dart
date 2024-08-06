class GetBank {
    final int status;
    final Data data;
    final String message;

    GetBank({
        required this.status,
        required this.data,
        required this.message,
    });

    factory GetBank.fromJson(Map<String, dynamic> json) => GetBank(
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
    final int bankAccountId;
    final String bankClabe;
    final String accountNumber;
    final String bankName;

    Data({
        required this.bankAccountId,
        required this.bankClabe,
        required this.accountNumber,
        required this.bankName,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bankAccountId: json["bank_account_id"],
        bankClabe: json["bank_clabe"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
    );

    Map<String, dynamic> toJson() => {
        "bank_account_id": bankAccountId,
        "bank_clabe": bankClabe,
        "account_number": accountNumber,
        "bank_name": bankName,
    };
}
