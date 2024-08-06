//Estructura de datos para suma total deposito
class TotalDeposit {
  final int status;
  final DepositSumtotal data;
  final String message;

  TotalDeposit({
    required this.status,
    required this.data,
    required this.message,
  });

  factory TotalDeposit.fromJson(Map<String, dynamic> json) => TotalDeposit(
        status: json["status"],
        data: DepositSumtotal.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class DepositSumtotal {
  final int totalDeposit;

  DepositSumtotal({
    required this.totalDeposit,
  });

  factory DepositSumtotal.fromJson(Map<String, dynamic> json) =>
      DepositSumtotal(
        totalDeposit: json["total_deposit"],
      );

  Map<String, dynamic> toJson() => {
        "total_deposit": totalDeposit,
      };
}
