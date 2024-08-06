class Deudores {
    final int status;
    final List<Datum> data;
    final String message;

    Deudores({
        required this.status,
        required this.data,
        required this.message,
    });

    factory Deudores.fromJson(Map<String, dynamic> json) => Deudores(
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
    final int saleid;
    final String nap;
    final String zone;
    final int money;
    final int payment;
    final int month;
    final int year;

    Datum({
        required this.saleid,
        required this.nap,
        required this.zone,
        required this.money,
        required this.payment,
        required this.month,
        required this.year,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        saleid: json["saleid"],
        nap: json["nap"],
        zone: json["zone"],
        money: json["money"],
        payment: json["payment"],
        month: json["month"],
        year: json["year"],
    );

    Map<String, dynamic> toJson() => {
        "saleid": saleid,
        "nap": nap,
        "zone": zone,
        "money": money,
        "payment": payment,
        "month": month,
        "year": year,
    };
}
