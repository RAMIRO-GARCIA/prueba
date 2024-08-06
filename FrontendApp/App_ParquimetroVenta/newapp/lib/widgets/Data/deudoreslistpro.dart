
class DeudoresList {
    final int status;
    final List<Datum> data;
    final String message;

    DeudoresList({
        required this.status,
        required this.data,
        required this.message,
    });

    factory DeudoresList.fromJson(Map<String, dynamic> json) => DeudoresList(
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
    final int idsale;
    final int idnap;
    final double balanceSold;
    final int totalabono;
    final double montopendiente;
    final int mes;
    final int year;

    Datum.Listdeudores({
        required this.idsale,
        required this.idnap,
        required this.balanceSold,
        required this.totalabono,
        required this.montopendiente,
        required this.mes,
        required this.year,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum.Listdeudores(
        idsale: json["idsale"],
        idnap: json["idnap"],
        balanceSold: json["balance_sold"]?.toDouble(),
        totalabono: json["totalabono"],
        montopendiente: json["montopendiente"]?.toDouble(),
        mes: json["mes"],
        year: json["year"],
    );

    Map<String, dynamic> toJson() => {
        "idsale": idsale,
        "idnap": idnap,
        "balance_sold": balanceSold,
        "totalabono": totalabono,
        "montopendiente": montopendiente,
        "mes": mes,
        "year": year,
    };
}
