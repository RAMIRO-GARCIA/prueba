import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructurePaymentByID.dart';
import 'package:newapp/widgets/Data/DataStructureSaleId.dart';
import 'package:newapp/widgets/Data/DataStructurePayments.dart';
import 'package:newapp/widgets/Data/DataStructurePaymentTotal.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:newapp/widgets/RegisterSale/PaymentEdit/EditRegisterSale.dart';
import 'package:newapp/widgets/RegisterSale/PaymentEdit/EditarAbono.dart';
import 'package:newapp/widgets/RegisterSale/ABONARcREDITO.dart';

class DetailPaymentdata extends StatefulWidget {
  final int? saleID;
  DetailPaymentdata({super.key, required this.saleID});

  @override
  State<DetailPaymentdata> createState() => _DetailPaymentdataState();
}

class _DetailPaymentdataState extends State<DetailPaymentdata> {
  final ApiService apiService = ApiService();
  late Future<SalesID?> salebyId;
  late Future<PaymentbyId?> dataPaymentFuture;
  late Future<PaymentMoney?> abonosdetail;
  late Future<Payments?> listabonos;
  double? abonosum;
  late Future<Operador?> operatorall;

  @override
  void initState() {
    super.initState();
    operatorall = apiService.getOperator();

    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      salebyId = apiService.getSalebyID(widget.saleID);
      dataPaymentFuture = apiService.getDataPayment(widget.saleID);
      listabonos = apiService.getPayments(widget.saleID);
      abonosdetail = apiService.getAbonos(widget.saleID);
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
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () {
                final route = MaterialPageRoute(
                  builder: (_) => const MainMenu(),
                );
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 236, 107, 2),
          child: Column(
            children: [
              FutureBuilder<SalesID?>(
                future: salebyId,
                builder:
                    (BuildContext context, AsyncSnapshot<SalesID?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                        child: Text('No hay datos disponibles'));
                  } else {
                    var saledata = snapshot.data!;
                    double? venta = saledata.data.salesAmount;

                    return Column(
                      children: [
                        const Text(
                          'Credito Detalle',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                          //textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 1),
                        const Icon(
                          Icons.storefront_outlined,
                          color: Colors.black,
                          size: 80,
                        ),
                        Text(
                          '${saledata.data.organizationname} ',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          'Encargado ${saledata.data.firstname} ${saledata.data.lastname}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: AutoSizeText(
                                    'Deuda \$${venta} ',
                                    style: TextStyle(fontSize: 15),
                                    minFontSize: 12,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                            FutureBuilder<PaymentMoney?>(
                                future: apiService.getAbonos(widget.saleID),
                                builder: (BuildContext context,
                                    AsyncSnapshot<PaymentMoney?> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child:
                                            Text('No hay datos disponibles'));
                                  } else {
                                    abonosum = snapshot.data?.data.money;

                                    return Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: AutoSizeText(
                                          'Abonos $abonosum',
                                          style: const TextStyle(fontSize: 15),
                                          minFontSize: 12,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (abonosum != null &&
                                    saledata.data.balanceSold > abonosum!) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          Abono(
                                        saleid: widget.saleID,
                                        ownerfirst: saledata.data.firstname,
                                        ownerlast: saledata.data.lastname,
                                        namenap: saledata.data.organizationname,
                                        credito: saledata.data.balanceSold,
                                        sumtotal: abonosum,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);
                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: ClipRect(
                                            child: child,
                                          ),
                                        );
                                      },
                                      transitionDuration: const Duration(
                                          seconds:
                                              1), // Duración de la transición (1 segundo)
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Ya se ha pagado")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // Color de fondo del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Borde del botón
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'Abonar',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Color del texto del botón
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 70,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FormSaleEdit(
                                          saleid: widget.saleID,
                                          amount: saledata.data.salesAmount,
                                          typesale: saledata.data.saleType,
                                          idnap: saledata.data.legacyResellerId,
                                          namenap:
                                              saledata.data.organizationname,
                                              tipo: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    abonosdetail.then((abonosData) {
                                      if (abonosData != null &&
                                          (abonosData.data.money == 0 ||
                                              abonosData.data.money == null)) {
                                        // Mostrar el diálogo de confirmación
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmación'),
                                              content: const Text(
                                                  '¿Confirma eliminación?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await apiService.deleteSale(
                                                        widget.saleID);
                                                    Navigator.of(context).pop();

                                                    final route =
                                                        MaterialPageRoute(
                                                      builder: (_) =>
                                                          const MainMenu(),
                                                    );
                                                    Navigator.push(
                                                        context, route);
                                                  },
                                                  child: const Text(
                                                    'Aceptar',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "No se puede eliminar, hay abonos registrados")));
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ); // Aquí se retorna correctamente el widget Text
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder<Payments?>(
                future: listabonos,
                builder:
                    (BuildContext context, AsyncSnapshot<Payments?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('No hay datos'),
                    );
                  } else {
                    var paymentsdata = snapshot.data;
                    return Container(
                      color: Colors.white, // Fondo blanco
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: paymentsdata!.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final payment = paymentsdata.data[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: AutoSizeText(
                                  "${payment.paymentAmount}",
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: AutoSizeText(
                                  'Fecha: ${payment.paymentDate}  ',
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                EditarAbono(
                                              saleid: widget.saleID,
                                              paymentid: payment.paymentId,
                                              amount: payment.paymentAmount,
                                              note: payment.paymentNote,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.easeInOut;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: ClipRect(
                                                  child: child,
                                                ),
                                              );
                                            },
                                            transitionDuration: const Duration(
                                                seconds:
                                                    1), // Duración de la transición (1 segundo)
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                  '¿Confirma eliminacion?'),
                                              Row(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      print('Cancelar');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                    },
                                                    child: const Text(
                                                      'Cancelar',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  TextButton(
                                                    onPressed: () async {
                                                      print('Aceptar');
                                                      await apiService
                                                          .deletePayment(payment
                                                              .paymentId);
                                                      setState(() {
                                                        listabonos = apiService
                                                            .getPayments(
                                                                widget.saleID);
                                                      });
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Aceptar',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
