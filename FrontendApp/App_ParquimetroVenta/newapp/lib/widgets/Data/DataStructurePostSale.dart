class SaletPost {
  final int status;
  final List<Datum> data;
  final String message;

  SaletPost({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SaletPost.fromJson(Map<String, dynamic> json) => SaletPost(
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
  final String? saleNumber;
  final String? saleType;
  final double? salesAmount;
  final double? balanceSold;
  final String? reference;
  final String? depositAccount;
  final int? promotionId;
  final int? operatorId;
  final int? operatorWallet;
  final double? walletPreviousFunds;
  final double? walletFinalFunds;
  final int? legacyResellerId;

  Datum({
    this.saleNumber,
    this.saleType,
    this.salesAmount,
    this.balanceSold,
    this.reference,
    this.depositAccount,
    this.promotionId,
    this.operatorId,
    this.operatorWallet,
    this.walletPreviousFunds,
    this.walletFinalFunds,
    this.legacyResellerId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        saleNumber: json["sale_number"]!,
        saleType: json["sale_type"]!,
        salesAmount: json["sales_amount"]?.toDouble(),
        balanceSold: json["balance_sold"]?.toDouble(),
        reference: json["reference"]!,
        depositAccount: json["deposit_account"]!,
        promotionId: json["promotion_id"],
        operatorId: json["operator_id"],
        operatorWallet: json["operator_wallet"],
        walletPreviousFunds: json["wallet_previous_funds"],
        walletFinalFunds: json["wallet_final_funds"]?.toDouble(),
        legacyResellerId: json["legacy_reseller_id"],
      );

  Map<String, dynamic> toJson() => {
        "sale_number": saleNumber,
        "sale_type": saleType,
        "sales_amount": salesAmount,
        "balance_sold": balanceSold,
        "reference": reference,
        "deposit_account": depositAccount,
        "promotion_id": promotionId,
        "operator_id": operatorId,
        "operator_wallet": operatorWallet,
        "wallet_previous_funds": walletPreviousFunds,
        "wallet_final_funds": walletFinalFunds,
        "legacy_reseller_id": legacyResellerId,
      };
}
