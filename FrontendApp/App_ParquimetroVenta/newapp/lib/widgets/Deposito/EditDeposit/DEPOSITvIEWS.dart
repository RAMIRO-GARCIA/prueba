import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureDepositDetail.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Deposito/EditDeposit/EDITdEPOSIT.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';

class DepositViews extends StatefulWidget {
  final int idDeposit;
  DepositViews({required this.idDeposit});

  @override
  State<DepositViews> createState() => _DepositViewsState();
}

class _DepositViewsState extends State<DepositViews> {
  final ApiService apiService = ApiService();
  late Future<GetDetailDeposit?> detailDepositFuture;
  late Future<Operador?> operatorall;

  @override
  void initState() {
    super.initState();
    operatorall = apiService.getOperator();
    detailDepositFuture = apiService.getDepositById(widget.idDeposit);

    _loadDepositDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDepositDetails();
  }

  void _loadDepositDetails() async {
    setState(() {
      operatorall = apiService.getOperator();

      detailDepositFuture = apiService.getDepositById(widget.idDeposit);
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
                  "${operador.data.firsname} ${operador.data.lastname}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            final route = MaterialPageRoute(
              builder: (_) => const MainMenu(),
            );
            Navigator.push(context, route);
          },
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: FutureBuilder<GetDetailDeposit?>(
        future: detailDepositFuture,
        builder:
            (BuildContext context, AsyncSnapshot<GetDetailDeposit?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron datos'));
          } else {
            return buildDepositDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildDepositDetails(GetDetailDeposit detailDeposit) {
    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 236, 107, 2),
          child: Row(
            children: [
              const Spacer(),
              const Text(
                'Depósito',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const Spacer(),
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
                              Navigator.of(context).pop(); // Cerrar el diálogo
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              apiService.deleteDeposit(widget.idDeposit);
                              print('Aceptar');
                              final route = MaterialPageRoute(
                                  builder: (_) => const MainMenu());
                              Navigator.push(context,
                                  route); // Regresar y enviar resultado
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
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Container(
              color: const Color.fromARGB(255, 236, 107, 2),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_atm,
                      size: 80,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    // Text(
                    // 'Cuenta bancaria: ${detailDeposit.data.bankAccountId}',
                    //  style: TextStyle(fontSize: 15, color: Colors.white),
                    //),
                    const SizedBox(height: 10),
                    Text(
                      'Cantidad del depositos: \$${detailDeposit.data.depositAmount}',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Fecha de creación: ${detailDeposit.data.creationDate}',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130),
                      child: TextButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FormEditDeposit(
                                idDeposit: widget.idDeposit,
                                year: detailDeposit.data.depositYear,
                                month: detailDeposit.data.depositMonth,
                                monto: detailDeposit.data.depositAmount,
                                reference: detailDeposit.data.bankAccountId,
                                evidencia: detailDeposit.data.depositReceipt,
                                date: detailDeposit.data.depositDate,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: ClipRect(
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(seconds: 1),
                            ),
                          );

                          if (result != null && result == true) {
                            _loadDepositDetails();
                          }
                        },
                        child: TextField(
                          textAlign: TextAlign.center,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Editar',
                            hintStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.blue,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
