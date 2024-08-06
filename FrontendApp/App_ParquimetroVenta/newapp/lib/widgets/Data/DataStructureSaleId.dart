class SalesID {
    final int status;
    final Sale data;
    final String message;

    SalesID({
        required this.status,
        required this.data,
        required this.message,
    });

    factory SalesID.fromJson(Map<String, dynamic> json) => SalesID(
        status: json["status"],
        data: Sale.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
    };
}

class Sale {
    final int saleId;
    final String saleNumber;
    final String saleType;
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
    final String organizationname;
    final String firstname;
    final String lastname;

    Sale({
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
        required this.organizationname,
        required this.firstname,
        required this.lastname,
    });

    factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        saleId: json["sale_id"],
        saleNumber: json["sale_number"],
        saleType: json["sale_type"],
        salesAmount: json["sales_amount"]?.toDouble() ?? 0.0,
        balanceSold: json["balance_sold"]?.toDouble() ?? 0.0,
        reference: json["reference"],
        depositAccount: json["deposit_account"],
        promotionId: json["promotion_id"],
        operatorId: json["operator_id"],
        operatorWallet: json["operator_wallet"],
        walletPreviousFunds: json["wallet_previous_funds"]?.toDouble() ?? 0.0,
        walletFinalFunds: json["wallet_final_funds"]?.toDouble() ?? 0.0,
        saleDate: DateTime.parse(json["sale_date"]),
        legacyResellerId: json["legacy_reseller_id"],
        organizationname: json["Organizationname"],
        firstname: json["firstname"],
        lastname: json["lastname"],
    );

    Map<String, dynamic> toJson() => {
        "sale_id": saleId,
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
        "sale_date": saleDate.toIso8601String(),
        "legacy_reseller_id": legacyResellerId,
        "Organizationname": organizationname,
        "firstname": firstname,
        "lastname": lastname,
    };
}
