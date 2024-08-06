import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureDepositonbankTotal.dart';
import 'package:newapp/widgets/Data/DataStructureGetPay.dart';
import 'package:newapp/widgets/Data/DataStructureLoginJWT.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructureSaleTotal.dart';
import 'package:newapp/widgets/Data/Databydeposit.dart';
import 'package:newapp/widgets/Data/bydeposit.dart';
import 'package:newapp/widgets/Data/carddeposittotal.dart';
import 'package:newapp/widgets/MainPromotor/ListViewDeudores.dart';
import 'package:newapp/widgets/MainPromotor/ListViewSales.dart';
import 'package:newapp/widgets/MainPromotor/ListViewDeposits.dart';
import 'package:newapp/widgets/infrastruture/models/modeles.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<int> list = [1, 2, 3, 4, 5];
  final ApiService apiService = ApiService();
  Color _colorVenta = Colors.green;
  Color _colorDeposito = Colors.white;
  late int nowmonth = 0;
  late int nowyear = 0;
  Sales? sales;
  late Future<TotalSale?> saleall;
  late Future<TotalDeposit?> depositall;
  DepositOnbankAll? depositonbankall;
  Widget ventasWidget = const AllSales();
  bool showDeudores = true;
  late int ventacredito;
  late int ventacontado;
  int? storedValue;
  late Future<Operador?> operatorall;
  //late Future<CardBydeposit?> totaldeposit;
  late Future<CardBydeposit?> bydeposit;
  late Future<SumarizacionEfectivo?> card3;
  late Future<GetPay?> card4;

  void obtenerFechaActual() {
    DateTime now = DateTime.now();
    nowmonth = now.month;
    nowyear = now.year;
  }

  @override
  void initState() {
    super.initState();
    ventacontado = 0;
    ventacredito = 0;
    obtenerFechaActual();
    setState(() {
      saleall = apiService.getTotalsale(nowmonth, nowyear);
      depositall = apiService.getTotalDeposit(nowmonth, nowyear);
      operatorall = apiService.getOperator();
      // totaldeposit = apiService.getTotaldeposit();
      card3 = apiService.getSumarizationCard3();
      card4 = apiService.getPay();
    });
    didChangeDependencies();
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
        saleall = apiService.getTotalsale(nowmonth, nowyear);
        depositall = apiService.getTotalDeposit(nowmonth, nowyear);
        operatorall = apiService.getOperator();
        //totaldeposit = apiService.getTotaldeposit();
        card3 = apiService.getSumarizationCard3();
        card4 = apiService.getPay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).size;
    var screenHeigth = a.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
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
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: const AppBarLowMain(),
        body: Padding(
          padding: EdgeInsets.all(screenHeigth / 45),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(196, 255, 86, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenHeigth / 100),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 160.0, // Altura del carrusel
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        viewportFraction: 0.8,
                      ),
                      items: [
                        // Card 1
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            color: const Color.fromARGB(255, 20, 36, 63),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<TotalSale?>(
                                future: saleall,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error: ${snapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red)));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text('No hay datos disponibles',
                                            style:
                                                TextStyle(color: Colors.grey)));
                                  } else {
                                    var datatotalsale = snapshot.data!;
                                    int totalventa = 0;

                                    if (datatotalsale.data.isNotEmpty &&
                                        datatotalsale.data.length > 1) {
                                      ventacontado =
                                          datatotalsale.data[0].saleTotal;
                                      int ventacredito =
                                          datatotalsale.data[1].saleTotal;
                                      totalventa = ventacontado + ventacredito;
                                      print("total venta: $totalventa");
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "Ventas del mes: \$ $totalventa",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          minFontSize: 10,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 10),

                                        if (datatotalsale.data.isNotEmpty)
                                          Text(
                                            "${datatotalsale.data[0].saleType}: \$${datatotalsale.data[0].saleTotal}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white70),
                                          ),
                                        if (datatotalsale.data.length > 1)
                                          Text(
                                            "${datatotalsale.data[1].saleType}: \$${datatotalsale.data[1].saleTotal}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white70),
                                          ),
                                        const SizedBox(
                                            height: 10), // Espacio adicional
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        // Card 2
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            color: const Color.fromARGB(255, 20, 36, 63),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<TotalDeposit?>(
                                future: depositall,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error: ${snapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red)));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text('No hay datos disponibles',
                                            style:
                                                TextStyle(color: Colors.grey)));
                                  } else {
                                    var datatotaldeposit = snapshot.data!;
                                    //int amountcontado = 0;
                                    int amountcredito = 0;
                                    int deposito = 0;
                                    if (datatotaldeposit.data.totalDeposit <
                                        ventacontado) {
                                      deposito =
                                          datatotaldeposit.data.totalDeposit -
                                              ventacredito;
                                      amountcredito = (datatotaldeposit
                                              .data.totalDeposit -
                                          (datatotaldeposit.data.totalDeposit -
                                              ventacredito));

                                      print("deposito: $deposito");
                                    } else if (datatotaldeposit
                                            .data.totalDeposit >
                                        ventacontado) {
                                      deposito = ventacontado;
                                      amountcredito =
                                          datatotaldeposit.data.totalDeposit -
                                              ventacontado;

                                      print(
                                          "deposito diferencensiacion: $deposito");
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "Depositado:  \$${datatotaldeposit.data.totalDeposit}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          minFontSize: 12,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'De contado: \$${deposito}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "De Abono: \$${amountcredito}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        // Card 3
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            color: const Color.fromARGB(255, 20, 36, 63),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<SumarizacionEfectivo?>(
                                future: card3,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error: ${snapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red)));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text('No hay datos disponibles',
                                            style:
                                                TextStyle(color: Colors.grey)));
                                  } else {
                                    var bydeposit = snapshot.data!;
                                    int A = 0;
                                    int suma = bydeposit.data[0].totalCash +
                                        bydeposit.data[1].totalCash;

                                    if (suma > bydeposit.data[2].totalCash) {
                                      A = (suma) -
                                          (bydeposit.data[2].totalCash);
                                      print(
                                          " INFORMACION::$suma ${bydeposit.data[2].totalCash}");
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "Efectivo para depositar:$A ",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          minFontSize: 10,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 2),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        // Card 4
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            color: const Color.fromARGB(255, 20, 36, 63),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<GetPay?>(
                                future: card4,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text('Error: ${snapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red)));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text('No hay datos disponibles',
                                            style:
                                                TextStyle(color: Colors.grey)));
                                  } else {
                                    var Sumarizacion = snapshot.data!;
                                    int B = 0;
                                    if (Sumarizacion.data.money > 0) {
                                      B = Sumarizacion.data.money;
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AutoSizeText(
                                          "Pendiente para cobrar:  ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          minFontSize: 10,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "${Sumarizacion.data.description} $B",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        ),
                                        
                                        const SizedBox(height: 2),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenHeigth / 15.7, vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.sell,
                              color: _colorVenta == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            label: Text(
                              'Ventas',
                              style: TextStyle(
                                color: _colorVenta == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _colorVenta,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _colorDeposito = Colors.white;
                                _colorVenta = Colors.green;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.account_balance_wallet,
                              color: _colorDeposito == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            label: Text(
                              'Depositos',
                              style: TextStyle(
                                color: _colorDeposito == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _colorDeposito,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _colorDeposito = Colors.blue;
                                _colorVenta = Colors.white;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            showDeudores = !showDeudores;
                            ventasWidget = showDeudores
                                ? DeudoresList(
                                    month: nowmonth,
                                  )
                                : const AllSales();
                            print("data boleana: $showDeudores");
                          });
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              if (_colorVenta == Colors.green)
                if (_colorDeposito == Colors.white) ventasWidget,
              if (_colorVenta == Colors.white)
                if (_colorDeposito == Colors.blue) const BankMoney(),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 227, 223, 223),
      ),
    );
  }
}
