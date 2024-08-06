//List view de las ventas (Credito y COntado)
import 'package:flutter/material.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/DataStructureSalesList.dart';
import 'package:newapp/widgets/RegisterSale/VIEWpAYMENTDETAIL.dart';
import 'package:newapp/widgets/RegisterSale/viewsale.dart';

class AllSales extends StatefulWidget {
  const AllSales({super.key});

  @override
  State<AllSales> createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  late Color colorText;
  final ApiService apiService = ApiService();
  Saleslist? salesList;
  int? storagevalue;
  @override
  void initState() {
    super.initState();
    fetchSales();
    // getSales();
  }

  void fetchSales() async {
    storagevalue = await SharedPrefsKeys.getStoredValue();
    if (storagevalue != 0) {
      Saleslist? data = await apiService.getSales();
      if (mounted) {
        setState(() {
          salesList = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: salesList == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: salesList!.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final sale = salesList!.data[index];
                  if (sale.saleType == "contado") {
                    colorText = Colors.green;
                  } else {
                    colorText = Colors.orange;
                  }
                  ;
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.blue,
                        size: 40,
                      ),
                      title: Text(
                        '${sale.reference} \$${sale.salesAmount.toStringAsFixed(2)} ${sale.saleType}',
                        style: TextStyle(
                          color: colorText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        sale.saleDate.toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.blue),
                      onTap: () {
                        print("la venta seleccionada es: ${sale.saleId}");
                        if (sale.saleType == "contado") {
                          final route = MaterialPageRoute(
                            builder: (_) => ViewSale(
                              saleid: sale.saleId,
                            ),
                          );
                          Navigator.push(context, route);
                        } else if (sale.saleType == "credito") {
                          final route = MaterialPageRoute(
                            builder: (_) =>
                                DetailPaymentdata(saleID: sale.saleId),
                          );
                          Navigator.push(context, route);
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
      ),
    );
  }
}
