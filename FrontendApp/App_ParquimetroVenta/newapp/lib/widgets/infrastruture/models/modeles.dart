class Sales {
    final int status;
    final List<Datum> data;
    final String message;

    Sales({
        required this.status,
        required this.data,
        required this.message,
    });

    factory Sales.fromJson(Map<String, dynamic> json) => Sales(
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
    final int saleId;
    final String saleNumber;
    final SaleType saleType;
    final double salesAmount;
    final double balanceSold;
    final String reference;
    final String depositAccount;
    final int promotionId;
    final int operatorId;
    final int operatorWallet;
    final double walletPreviousFunds;
    final double walletFinalFunds;
    final DateTime saleDate;
    final int legacyResellerId;

    Datum({
        required this.saleId,
        required this.saleNumber,
        required this.saleType,
        required this.salesAmount,
        required this.balanceSold,
        required this.reference,
        required this.depositAccount,
        required this.promotionId,
        required this.operatorId,
        required this.operatorWallet,
        required this.walletPreviousFunds,
        required this.walletFinalFunds,
        required this.saleDate,
        required this.legacyResellerId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        saleId: json["sale_id"],
        saleNumber: json["sale_number"],
        saleType: saleTypeValues.map[json["sale_type"]]!,
        salesAmount: json["sales_amount"]?.toDouble(),
        balanceSold: json["balance_sold"]?.toDouble(),
        reference: json["reference"]!,
        depositAccount: json["deposit_account"],
        promotionId: json["promotion_id"],
        operatorId: json["operator_id"],
        operatorWallet: json["operator_wallet"],
        walletPreviousFunds: json["wallet_previous_funds"]?.toDouble(),
        walletFinalFunds: json["wallet_final_funds"]?.toDouble(),
        saleDate: DateTime.parse(json["sale_date"]),
        legacyResellerId: json["legacy_reseller_id"],
    );

    Map<String, dynamic> toJson() => {
        "sale_id": saleId,
        "sale_number": saleNumber,
        "sale_type": saleTypeValues.reverse[saleType],
        "sales_amount": salesAmount,
        "balance_sold": balanceSold,
        "reference": reference,
        "deposit_account":depositAccount,
        "promotion_id": promotionId,
        "operator_id": operatorId,
        "operator_wallet": operatorWallet,
        "wallet_previous_funds": walletPreviousFunds,
        "wallet_final_funds": walletFinalFunds,
        "sale_date": saleDate.toIso8601String(),
        "legacy_reseller_id": legacyResellerId,
    };
}



enum SaleType {
    CONTADO,
    CREDITO
}

final saleTypeValues = EnumValues({
    "contado": SaleType.CONTADO,
    "credito": SaleType.CREDITO
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}