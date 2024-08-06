class Operador {
    final int status;
    final Data data;
    final String message;

    Operador({
        required this.status,
        required this.data,
        required this.message,
    });

    factory Operador.fromJson(Map<String, dynamic> json) => Operador(
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
    final String firsname;
    final String lastname;

    Data({
        required this.id,
        required this.firsname,
        required this.lastname,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firsname: json["firsname"],
        lastname: json["lastname"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firsname": firsname,
        "lastname": lastname,
    };
}
