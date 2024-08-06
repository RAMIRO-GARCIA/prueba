//Servicios
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/Data/DataStructureDepositDetail.dart';
import 'package:newapp/widgets/Data/DataStructureDepositList.dart';
import 'package:newapp/widgets/Data/DataStructureDeposits.dart';
import 'package:newapp/widgets/Data/DataStructureGetPay.dart';
import 'package:newapp/widgets/Data/DataStructureLoginJWT.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructurePaymentByID.dart';
import 'package:newapp/widgets/Data/DataStructurePromotion.dart';
import 'package:newapp/widgets/Data/DataStructureReference.dart';
import 'package:newapp/widgets/Data/DataStructureSaleId.dart';
import 'package:newapp/widgets/Data/DataStructureSaleTotal.dart';
import 'package:newapp/widgets/Data/DataStructureSalesList.dart';
import 'package:newapp/widgets/Data/DataStructurePayments.dart';
import 'package:newapp/widgets/Data/DataStructurePaymentTotal.dart';
import 'package:newapp/widgets/Data/DataStructureUrlImage.dart';
import 'package:newapp/widgets/Data/DataStructureNaps.dart';
import 'package:newapp/widgets/Data/Databydeposit.dart';
import 'package:newapp/widgets/Data/bydeposit.dart';
import 'package:newapp/widgets/Data/carddeposittotal.dart';
import 'package:newapp/widgets/Data/deudores.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080";
  //final Dio dio = Dio();
  UrlImage? urlImage;
  List<Nap> napsList = [];
  List<Nap> filteredNapsList = [];
  int storedValue = 0;

  ApiService() {
    _initializeStoredValue();
  }
  Dio _createDio() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 50);
    dio.options.receiveTimeout = const Duration(seconds: 50);
    return dio;
  }

  Future<void> _initializeStoredValue() async {
    storedValue = await SharedPrefsKeys.getStoredValue();
  }

//Peticion de sumatoria de abonos
  Future<PaymentMoney?> getAbonos(int? sale) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/payments/total/$sale/");
      return PaymentMoney.fromJson(response.data);
    } catch (e) {
      print("La consulta de suma total de abono $e");
      return null;
    }
  }

//Peticion de abonos por id(venta)
  Future<PaymentbyId?> getDataPayment(int? sale) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/payments/$sale/");

      return PaymentbyId.fromJson(response.data);
    } catch (e) {
      print("Error en la obtencion de data payment $e");
      return null;
    }
  }

//Peticion de ventas
  Future<Saleslist?> getSales() async {
    final prefs = await SharedPreferences.getInstance();

    final dio = _createDio();
    print("la url es de: $baseUrl/api/sales/operator/$storedValue/");
    if (storedValue != 0) {
      try {
        var response =
            await dio.get("$baseUrl/api/sales/operator/$storedValue/");
        return Saleslist.fromJson(response.data);
      } catch (e) {
        print("Error en la obtencion de data de ventas $e");
        return null;
      }
    }
  }

//Peticion de ventas por id
  Future<SalesID?> getSalebyID(int? id) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/sales/$id/");
      return SalesID.fromJson(response.data);
    } catch (e) {
      print("Error en la obtencion de data de ventas por id: $e");
      return null;
    }
  }

  //Peticio DELETE para eliminar una venta
  Future<void> deleteSale(int? id) async {
    final dio = _createDio();
    try {
      var response = dio.delete("$baseUrl/api/sales/$id/");
    } catch (e) {
      print("Error al eliminar venta: $e");
    }
  }

  //Peticion de abonos
  Future<Payments?> getPayments(int? id) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/payments/$id/");
      return Payments.fromJson(response.data);
    } catch (e) {
      print("Error en la peticion de data en payments: $e");
    }
  }

  //Peticion del login Metodo Post
  Future<LoginJwt?> postLogin(String email, String password) async {
    final dio = _createDio();
    try {
      var response = await dio.post("$baseUrl/login/",
          data: {"email": email, "password": password});
      return LoginJwt.fromJson(response.data);
    } catch (e) {
      print("Error en el login: $e");
    }
  }

  //Peticion GET para obtener informacion del operador
  Future<Operador?> getOperator() async {
    final dio = _createDio();
    final prefs = await SharedPreferences.getInstance();
    Operador? data;
    try {
      var response = await dio.get("$baseUrl/api/operator/$storedValue/");
      print("data de la peticion: ${response.statusCode}, ${response.data}");
      data = Operador.fromJson(response.data);
      await prefs.setString("name", data.data.firsname);
      await prefs.setString("lastname", data.data.lastname);
      return data;
    } catch (e) {
      print("Error en la peticion de informacion del operador ${storedValue}");
    }
  }

  //Peticion POST para registro de ventas
  Future<void> postSale(String tipo, String amount, String reference,
      int promotion, int legacy, double balancesold) async {
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        double cantidad = double.parse(amount);
        var response = await dio.post("$baseUrl/api/sales/", data: {
          "sale_type": tipo,
          "sales_amount": cantidad,
          "balance_sold": balancesold,
          "reference": reference,
          "promotion_id": promotion,
          "operator_id": storedValue,
          "operator_wallet": 1,
          "legacy_reseller_id": legacy
        });
        if (response.statusCode == 200) {
          print(
              "Se guardo correctamente los datos de la venta: ${response.statusCode}");
        }
      } catch (e) {
        print(e);
      }
    }
  }

///////////
/////
  ///error cambiar el id de la promocion por default
  //Peticion PUT de ACtualizacion de ventas
  Future<void> updateSale(int? id, String tipo, String amount, String reference,
      int? promotion, int legacy, double balancesold) async {
       int storedWallet = await SharedPrefsKeys.getStoredWallet();
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        if (promotion != null || promotion == 0) {
          promotion = 21;
        } else {
          promotion = promotion;
        }

        double cantidad = double.parse(amount);

        var response = await dio.put("$baseUrl/api/sales/update/$id/", data: {
          "sale_number": "123456",
          "sale_type": tipo,
          "sales_amount": cantidad,
          "balance_sold": balancesold,
          "reference": reference,
          "deposit_account": "ACC456",
          "promotion_id": promotion,
          "operator_id": storedValue,
          "operator_wallet": storedWallet,
          "wallet_previous_funds": 0,
          "wallet_final_funds": 0,
          "legacy_reseller_id": legacy
        });
        if (response.statusCode == 200) {
          print(
              "Se guardo correctamente los datos de la venta: ${response.data}");
          print("promo id ${promotion}");
        } else {
          print("Error al actualizar la venta: ${response.statusCode}");
        }
      } catch (e) {
        print("Error en la actulizacion de la venta $e");
      }
    }
  }

  //Peticion GET para obtener las promociones
  Future<PromotionToday?> getPromotion(
    int idZone,
  ) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/sales/promotios/$idZone/");
      if (response.statusCode == 200) {
        return PromotionToday.fromJson(response.data);
      }
    } catch (e) {
      print("Error en la peticion de promocion: $e");
    }
  }

  //Peticion Post para registrar abono
  Future<void> postRegisterPayment(
      int? saleid, String amount, String? description) async {
    final dio = _createDio();
    storedValue = await SharedPrefsKeys.getStoredValue();

    if (storedValue != 0) {
      try {
        double money = double.parse(amount);

        var response = await dio.post("$baseUrl/api/payments/", data: {
          "sale_id": saleid,
          "operator_id": storedValue,
          "payment_amount": money,
          "payment_note": description ?? ""
        });
        if (response.statusCode == 200) {
          print("Abono registrado con exito");
        }
      } catch (e) {
        print("Error en el post de abono: $e");
      }
    }
  }

//Peticion DELETE para eliminar abono
  Future<void> deletePayment(int? id) async {
    final dio = _createDio();
    try {
      var response = await dio.delete("$baseUrl/api/paymentbyid/$id/");
      if (response.statusCode == 200) {
        print("Se elimino el abono con exito");
      }
    } catch (e) {
      print("Error en la eliminacion de abono: $e");
    }
  }

  //Peticion para edita abono (cantidad y nota)
  Future<void> putPayment(int id, String amount, String? description) async {
    final dio = _createDio();
    try {
      double money = double.parse(amount);

      var response = await dio.put("$baseUrl/api/paymentbyid/$id/",
          data: {"payment_amount": money, "payment_note": description});
      if (response.statusCode == 200) {
        print("Se edito el abono con exito");
      }
    } catch (e) {
      print("Error en la edicion de abono: $e");
    }
  }

//Peticion GET para consultar lista depositos
//Consumo de Endpoint para obtener total de ventas por mes del operador
  Future<Depositslist?> getDeposits() async {
    storedValue = await SharedPrefsKeys.getStoredValue();
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        var response =
            await dio.get("$baseUrl/api/deposits/list/$storedValue/");

        return Depositslist.fromJson(response.data);
      } catch (e) {
        print("error en la peticion depositos: $e");
      }
    }
  }

  //Peticion para obtener el deposito por id
  Future<GetDetailDeposit?> getDepositById(int id) async {
    final dio = _createDio();
    try {
      var response = await dio.get("$baseUrl/api/deposits/by/$id/");
      if (response.statusCode == 200) {
        print("Se obtuvo el deposito con exito");
        return GetDetailDeposit.fromJson(response.data);
      }
    } catch (e) {
      print("Error en la obtencion de deposito: $e");
    }
  }

  //Peticion para obtener las referencias bancarias
  Future<Referencias?> getReferences() async {
    final prefs = await SharedPreferences.getInstance();
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        var response = await dio.get('$baseUrl/api/references/$storedValue/');
        print('url de bank es: $baseUrl/api/references/$storedValue/');
        print("La data de las referencias bancarias ${response.data}");
        return Referencias.fromJson(response.data);
      } catch (e) {
        print("Error en la obtencion de referencias: $e");
      }
    }
  }

  //Peticion para guardar la imagen a AWS
  Future<UrlImage?> uploadImageToServer(File imageFile) async {
    print("imagen del post:  $imageFile");
    String fileName = "imagen.jpg";

    try {
      // Crea el FormData con el archivo
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(imageFile.path, filename: fileName),
      });

      // Crea una instancia de Dio
      final dio = _createDio();

      // Realiza la solicitud POST
      Response response =
          await dio.post("$baseUrl/api/imagen/", data: formData);

      if (response.statusCode == 200) {
        print("Imagen subida correctamente");
        print("Response data: ${response.data}");
        return UrlImage.fromJson(response.data);
      } else {
        print("Error al subir imagen: ${response.statusCode}");
        print("Response data: ${response.data}");
      }
    } catch (e) {
      print("Error al subir imagen: $e");
    }
  }

//Peticion POST para guardar informacion de deposito
  Future<void> postDeposit(
      String amount,
      String year,
      int? monthPosition,
      String date,
      String note,
      int? referenceDeposit,
      String? imagenurl) async {
    if (storedValue != 0) {
      try {
        double amountdeposit = double.parse(amount);
        int yeardeposit = int.parse(year);
        var dio = Dio();
        var response = await dio.post("$baseUrl/api/deposits/", data: {
          "deposit_amount": amountdeposit,
          "deposit_year": yeardeposit,
          "deposit_month": monthPosition,
          "deposit_receipt": imagenurl,
          "deposit_date": date,
          "deposit_notes": note,
          "operator_id": storedValue,
          " bank_account_id": referenceDeposit
        });
        if (response.statusCode == 200) {
          print(
              "Se guardo correctamente los datos del deposito: ${response.statusCode}");
          print(" notaaa: $note");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  //Peticion put para actualizar deposito
  Future<void> updateDeposit(
      int id,
      String amount,
      String year,
      int month,
      String? receipt,
      int bank,
      String? note,
      String update,
      String? date) async {
    final dio = _createDio();
    double? cantidad = double.tryParse(amount);
    int? yearup = int.tryParse(year);

    if (storedValue != 0) {
      try {
        var response = await dio.put("$baseUrl/api/deposits/$id/", data: {
          "deposit_amount": cantidad,
          "deposit_year": yearup,
          "deposit_month": month,
          "deposit_receipt": receipt,
          "deposit_date": date,
          "deposit_notes": note,
          "operator_id": storedValue,
          " bank_account_id": bank,
          "creation_date": update
        });
      } catch (e) {
        print("Error en la actualizacion del deposito: $e");
      }
    }
  }

  //Peticion para eliminar deposito
  Future<void> deleteDeposit(int id) async {
    final dio = _createDio();
    try {
      var response = await dio.delete("$baseUrl/api/depositsbyid/$id/");
    } catch (e) {
      print("Error en la eliminacion del deposito: $e");
    }
  }

  //Peticion para listas las naps
  Future<List<Nap>?> getNapsData() async {
    final dio = _createDio();

    try {
      var response = await dio.get("$baseUrl/api/naps/");

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        return data.map<Nap>((item) => Nap.fromJson(item)).toList();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<TotalSale?> getTotalsale(int month, int year) async {
    final dio = _createDio();
    late TotalSale? data;
    storedValue = await SharedPrefsKeys.getStoredValue();
    if (storedValue != 0) {
      try {
        final response = await dio
            .get("$baseUrl/api/sales/total/$month/$year/$storedValue/");
        print("respuesta del get data sumatotal \$$baseUrl/api/sales/total/$month/$year/$storedValue/: ${response.data}");
        if (response.statusCode == 200) {
          data = TotalSale.fromJson(response.data);
          return data;
        } else {
          throw Exception("Error en la solicitud: ${response.statusCode}");
        }
      } catch (e) {
        print("Error la petición de total de ventas: $e");
        return null;
      }
    }
  }

  //Peticion para obtener la suma total de lo depositado a cuenta kigo del mes
  Future<TotalDeposit?> getTotalDeposit(int month, int year) async {
    final dio = _createDio();

    if (storedValue != 0) {
      print(
          "Url de la peticion card 2: $baseUrl/api/deposits/total/$month/$year/$storedValue/");
      try {
        var response = await dio
            .get("$baseUrl/api/deposits/total/$month/$year/$storedValue/");
        return TotalDeposit.fromJson(response.data);
      } catch (e) {
        print("Error en la peticion de suma total de depositos $e");
      }
    }
  }

//Solucionar
  //Peticion GET para consulta efectivo para depositar
  Future<CardBydeposit?> getTotaldeposits() async {
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        var response = await dio.get("$baseUrl/api/bydeposits/$storedValue/");
        print("El ID storage: $baseUrl/api/bydeposits/$storedValue/");
        print("Data de efectivo para depositar: ${response.data}");
        return CardBydeposit.fromJson(response.data);
      } catch (e) {
        print("Error en la consulta de efectivo para depositar: $e");
        print("Error en la consulta de efectivo para depositar: $storedValue");
      }
    }
    return null; // Asegúrate de retornar null si no se cumple la condición
  }

  //Peticion Get para visualizar sumarizacion de ventas , abonos y depositos
  Future<SumarizacionEfectivo?> getSumarizationCard3() async {
    final dio = _createDio();
    storedValue = await SharedPrefsKeys.getStoredValue();
    if (storedValue != 0) {
      try {
        var response = await dio.get("$baseUrl/api/bydeposits/$storedValue/");
        print("la url de sumarizacion:$baseUrl/api/bydeposits/$storedValue/");
        print("data de card 3 ${response.data}");
        return SumarizacionEfectivo.fromJson(response.data);
      } catch (e) {
        print("Error en la peticion del card 3: $e");
      }
    }
  }

  //Peticion Get de ventas a credito para liquidar cantidad
  Future<GetPay?> getPay() async {
    storedValue = await SharedPrefsKeys.getStoredValue();
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        var response = await dio.get("$baseUrl/api/money/by/phy/$storedValue/");
        print(
            "la url de sumarizacion: $baseUrl/api/money/by/phy/$storedValue/");
        return GetPay.fromJson(response.data);
      } catch (e) {
        print("Error en la peticion del card 4 : $e");
      }
    }
  }

  //Peticion GET para obtener la lista de naps que aun adeudan
  Future<Deudores?> getDeudores() async {
    final dio = _createDio();
    if (storedValue != 0) {
      try {
        var response =
            await dio.get("$baseUrl/api/sales/deudores/$storedValue/");
        print("la url de deudores: $baseUrl/api/sales/deudores/$storedValue/");
        print("data de deudores: ${response.data}");
        return Deudores.fromJson(response.data);
      } catch (e) {
        print("Error en la peticion de listar deudores $e");
        return null;
      }
    }
  }

  //Consumo de Endpoint para visualizar total por depositar durante el mes
  Future<DepositAll?> getTotalByDeposit(int nowmonth, int nowyear) async {
    final dio = _createDio();
    try {
      var response =
          await dio.get("$baseUrl/api/bydeposits/total/$nowmonth/$nowyear/2/");

      return DepositAll.fromJson(response.data);
    } on DioException catch (e) {
      print("Error en total deposito: $e");
    }
  }
}
