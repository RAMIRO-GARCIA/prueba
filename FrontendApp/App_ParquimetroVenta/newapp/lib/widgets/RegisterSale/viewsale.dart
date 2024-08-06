import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructureSaleId.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:newapp/widgets/RegisterSale/PaymentEdit/EditRegisterSale.dart';

class ViewSale extends StatefulWidget {
  final int? saleid;

  ViewSale({super.key, required this.saleid});

  @override
  State<ViewSale> createState() => _ViewSaleState();
}

class _ViewSaleState extends State<ViewSale> {
  final ApiService apiService = ApiService();
  late Future<SalesID?> saledetail;
  late Future<Operador?> operatorall;

  @override
  void initState() {
    super.initState();
    _loadingdata();
    operatorall = apiService.getOperator();
  }

  void _loadingdata()async {
    setState(() {
      saledetail = apiService.getSalebyID(widget.saleid);
      operatorall = apiService.getOperator();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 10,
        backgroundColor: const Color.fromARGB(255, 20, 36, 63),
        title: FutureBuilder<Operador?>(
          future: operatorall,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.white);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No data available',
                  style: TextStyle(color: Colors.white));
            } else {
              var operador = snapshot.data!;
              return Center(
                child: Text(
                  "${operador.data.firsname} ${operador.data.lastname}", // Cambia 'name' por el atributo que necesites
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainMenu()),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<SalesID?>(
            future: saledetail,
            builder: (BuildContext context, AsyncSnapshot<SalesID?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No hay datos disponibles'));
              } else {
                var saledata = snapshot.data!;
                return Column(
                  children: [
                    SaleDetailCard(saledata: saledata, saleid: widget.saleid),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.shopping_cart_checkout_rounded,
                      size: 200,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class SaleDetailCard extends StatelessWidget {
  const SaleDetailCard({
    Key? key,
    required this.saledata,
    required this.saleid,
  }) : super(key: key);

  final SalesID saledata;
  final int? saleid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 107, 2),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Venta Detalle',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            const Icon(
              Icons.shopping_cart_checkout,
              color: Colors.black,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Nombre Nap ${saledata.data.organizationname}',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Cantidad a cobrar ${saledata.data.balanceSold}',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Fecha ${saledata.data.saleDate}',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormSaleEdit(
                            saleid: saleid,
                            amount: saledata.data.salesAmount,
                            typesale: saledata.data.saleType,
                            idnap: saledata.data.legacyResellerId,
                            namenap: saledata.data.organizationname,
                            tipo: 1,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Editar",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      iconColor: Colors.black,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmación'),
                            content: const Text('¿Confirma eliminación?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await ApiService().deleteSale(saleid);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const MainMenu()),
                                  );
                                },
                                child: const Text(
                                  'Aceptar',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
