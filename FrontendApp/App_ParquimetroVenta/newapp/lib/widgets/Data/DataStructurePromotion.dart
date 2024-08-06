class PromotionToday {
    final int status;
    final Data data;
    final String message;

    PromotionToday({
        required this.status,
        required this.data,
        required this.message,
    });

    factory PromotionToday.fromJson(Map<String, dynamic> json) => PromotionToday(
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
    final int id;
    final String promotionType;
    final String promotionValue;

    Data({
        required this.id,
        required this.promotionType,
        required this.promotionValue,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["ID"] ?? 1,
        promotionType: json["PromotionType"]?? "Num",
        promotionValue: json["PromotionValue" "0"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "PromotionType": promotionType,
        "PromotionValue": promotionValue,
    };
}
