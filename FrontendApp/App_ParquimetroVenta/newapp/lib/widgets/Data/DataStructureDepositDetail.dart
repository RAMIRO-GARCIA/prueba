class GetDetailDeposit {
    final int status;
    final Data data;
    final String message;

    GetDetailDeposit({
        required this.status,
        required this.data,
        required this.message,
    });

    factory GetDetailDeposit.fromJson(Map<String, dynamic> json) => GetDetailDeposit(
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
    final int depositId;
    final double depositAmount;
    final int depositYear;
    final int depositMonth;
    final String depositReceipt;
    final DateTime depositDate;
    final String depositNotes;
    final int operatorId;
    final int bankAccountId;
    final DateTime creationDate;

    Data.Deposit({
        required this.depositId,
        required this.depositAmount,
        required this.depositYear,
        required this.depositMonth,
        required this.depositReceipt,
        required this.depositDate,
        required this.depositNotes,
        required this.operatorId,
        required this.bankAccountId,
        required this.creationDate,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data.Deposit(
        depositId: json["deposit_id"],
        depositAmount: json["deposit_amount"]?.toDouble(),
        depositYear: json["deposit_year"],
        depositMonth: json["deposit_month"],
        depositReceipt: json["deposit_receipt"],
        depositDate: DateTime.parse(json["deposit_date"]),
        depositNotes: json["deposit_notes"],
        operatorId: json["operator_id"],
        bankAccountId: json[" bank_account_id"],
        creationDate: DateTime.parse(json["creation_date"]),
    );

    Map<String, dynamic> toJson() => {
        "deposit_id": depositId,
        "deposit_amount": depositAmount,
        "deposit_year": depositYear,
        "deposit_month": depositMonth,
        "deposit_receipt": depositReceipt,
        "deposit_date": "${depositDate.year.toString().padLeft(4, '0')}-${depositDate.month.toString().padLeft(2, '0')}-${depositDate.day.toString().padLeft(2, '0')}",
        "deposit_notes": depositNotes,
        "operator_id": operatorId,
        " bank_account_id": bankAccountId,
        "creation_date": creationDate.toIso8601String(),
    };
}
