import 'package:dio/dio.dart';

Future<void> _postSale(
  String saleNumber,
    String saleType,
    double salesAmount,
    double balanceSold,
    String reference,
    String depositAccount,
    int promotionId,
    int operatorId,
    int operatorWallet,
    double walletPreviousFunds,
    double walletFinalFunds,
    int legacyResellerId) async {
    final saleData = {
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
      //"sale_date": DateTime.now().toIso8601String(),
      "legacy_reseller_id": legacyResellerId,
    };

    try {
      final response = await Dio().post(
        'http://localhost:8080/api/sales/',
        data: saleData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        print('Venta creada exitosamente');
      } else {
        // Error del servidor
        print('Error en la creación de la venta: ${response.statusCode}');
      }
    } catch (e) {
      // Error en la solicitud
      print('Error: $e');
    }
  }
