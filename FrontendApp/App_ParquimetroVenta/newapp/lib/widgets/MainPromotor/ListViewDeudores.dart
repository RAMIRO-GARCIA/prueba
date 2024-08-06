import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/deudores.dart';
import 'package:newapp/widgets/RegisterSale/VIEWpAYMENTDETAIL.dart';

class DeudoresList extends StatefulWidget {
  final int? month;
  const DeudoresList({super.key, this.month});

  @override
  State<DeudoresList> createState() => _DeudoresListState();
}

class _DeudoresListState extends State<DeudoresList> {
  late Color colorText;
  final ApiService apiService = ApiService();
  late Future<Deudores?> deudoresList;
  int? storedValue;
  @override
  void initState() {
    super.initState();
    setState(() {
      deudoresList = apiService.getDeudores();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    storedValue = await SharedPrefsKeys.getStoredValue();
    setState(() {
      if (storedValue != 0) {
        deudoresList = apiService.getDeudores();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
          child: Expanded(
        child: FutureBuilder<Deudores?>(
          future: deudoresList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final deudores = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: deudores.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final sale = deudores.data[index];
                  if (sale.month == widget.month) {
                    colorText = Colors.orange;
                  } else {
                    colorText = Colors.red;
                  }

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
                        sale.nap,
                        style: TextStyle(
                          color: colorText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Venta:\$${sale.money} Abonado:\$${sale.payment}',
                        //"${sale.month} /${sale.year}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.sell, color: Colors.red),
                      onTap: () {
                        print("la venta seleccionada es: ${sale.saleid}");

                        final route = MaterialPageRoute(
                          builder: (_) =>
                              DetailPaymentdata(saleID: sale.saleid),
                        );
                        Navigator.push(context, route);
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            }
          },
        ),
      )),
    );
  }
}
