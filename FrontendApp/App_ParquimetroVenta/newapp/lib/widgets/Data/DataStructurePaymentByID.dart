class PaymentbyId {
  final int status;
  final Data data;
  final String message;

  PaymentbyId({
    required this.status,
    required this.data,
    required this.message,
  });

  factory PaymentbyId.fromJson(Map<String, dynamic> json) => PaymentbyId(
        status: json["status"] ?? 0,
        data: Data.fromJson(json["data"] ?? {}),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  final int paymentId;
  final int saleId;
  final int operatorId;
  final double paymentAmount;
  final DateTime paymentDate;
  final String paymentDateUpdate;
  final String paymentNote;

  Data({
    required this.paymentId,
    required this.saleId,
    required this.operatorId,
    required this.paymentAmount,
    required this.paymentDate,
    required this.paymentDateUpdate,
    required this.paymentNote,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentId: json["payment_id"] ?? 0,
        saleId: json["sale_id"] ?? 0,
        operatorId: json["operator_id"] ?? 0,
        paymentAmount: json["payment_amount"]?.toDouble() ?? 0.0,
        paymentDate: json["payment_date"] != null
            ? DateTime.parse(json["payment_date"])
            : DateTime.now(),
        paymentDateUpdate: json["payment_date_update"] ?? "",
        paymentNote: json["payment_note"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "sale_id": saleId,
        "operator_id": operatorId,
        "payment_amount": paymentAmount,
        "payment_date": paymentDate.toIso8601String(),
        "payment_date_update": paymentDateUpdate,
        "payment_note": paymentNote,
      };
}
