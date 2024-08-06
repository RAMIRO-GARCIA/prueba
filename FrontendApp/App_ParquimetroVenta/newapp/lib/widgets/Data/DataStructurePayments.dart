
class Payments {
    final int status;
    final List<Payment> data;
    final String message;

    Payments({
        required this.status,
        required this.data,
        required this.message,
    });

    factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        status: json["status"],
        data: List<Payment>.from(json["data"].map((x) => Payment.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Payment {
    final int paymentId;
    final int saleId;
    final int operatorId;
    final double paymentAmount;
    final DateTime paymentDate;
    final String paymentNote;

    Payment({
        required this.paymentId,
        required this.saleId,
        required this.operatorId,
        required this.paymentAmount,
        required this.paymentDate,
        required this.paymentNote,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentId: json["payment_id"],
        saleId: json["sale_id"],
        operatorId: json["operator_id"],
        paymentAmount: json["payment_amount"]?.toDouble(),
        paymentDate: DateTime.parse(json["payment_date"]),
        paymentNote: json["payment_note"],
    );

    Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "sale_id": saleId,
        "operator_id": operatorId,
        "payment_amount": paymentAmount,
        "payment_date": paymentDate.toIso8601String(),
        "payment_note": paymentNote,
    };
}
