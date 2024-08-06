import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/DataStructureLoginJWT.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructurePromotion.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:newapp/widgets/RegisterSale/VIEWpAYMENTDETAIL.dart';
import 'package:newapp/widgets/RegisterSale/viewsale.dart';

class ScreenConfirmationSale extends StatefulWidget {
  final int? id;
  final String organizationName;
  final int idNap;
  final String ventaTipo;
  final String cantidad;
  final int idZone;
  final String iddisc;

  const ScreenConfirmationSale(
      {super.key,
      this.id,
      required this.organizationName,
      required this.idNap,
      required this.ventaTipo,
      required this.cantidad,
      required this.idZone,
      required this.iddisc});

  @override
  State<ScreenConfirmationSale> createState() => _ScreenConfirmationSaleState();
}

class _ScreenConfirmationSaleState extends State<ScreenConfirmationSale> {
  final ApiService apiService = ApiService();
  PromotionToday? promotion;
  double balancesold = 0.0;
  double descuento = 0.0;
  String? provisional = "";
  TextEditingController _controllerNote = TextEditingController();
  late Future<Operador?> operatorall;

  String? provisionalString = "no  hay datos";

  @override
  void initState() {
    super.initState();
    _loaddata();
    operatorall = apiService.getOperator();
  }

  void _loaddata() async {
    promotion = await apiService.getPromotion(
      widget.idZone,
    );
    operatorall = apiService.getOperator();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * 0.1;
    double containerWidth = screenWidth * 0.8;

    double venta = double.parse(widget.cantidad);
    if (promotion?.data.promotionType == "Discount" ||
        promotion?.data.promotionType == "Num") {
      String descuentoString = promotion?.data.promotionValue ?? "0.0";
      descuento = double.parse(descuentoString);
      provisional = descuentoString;
      provisionalString = promotion?.data.promotionType;
      balancesold = venta - descuento;
    } else if (promotion?.data.promotionType == "Porcetaje") {
      String? descuentoString = promotion?.data.promotionValue;
      descuento = double.parse(descuentoString!.replaceAll('%', ''));
      balancesold = venta - (venta * descuento / 100);
      provisional = descuentoString;
      provisionalString = promotion?.data.promotionType;
    }
    if (promotion?.data.promotionType == null) {
      balancesold = venta - 0;
    }

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
          icon: const Icon(Icons.person, size: 50, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: containerHeight * 0.3,
              vertical: containerWidth * 0.1),
          child: Column(
            children: [
              Text(
                widget.iddisc,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    // url provicional
                    'https://mybucket-kigo.s3.us-east-2.amazonaws.com/uploads/LOGO-BUTTON.jpg',
                    scale: 1, // Escala de la imagen
                    height: 150, // Altura deseada de la imagen
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 150, // Ancho del contenedor de loading
                        height: 150, // Altura del contenedor de loading
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(), // Indicador de progreso circular
                            const SizedBox(height: 10),
                            const Text('Cargando'), // Mensaje de carga
                          ],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        child: const Text(
                            'Error al cargar la imagen'), // Mensaje de error
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Se creó una  venta a ${widget.ventaTipo} a ${widget.organizationName} por una cantidad de \$${widget.cantidad}, promoción del día $provisionalString: -$provisional  Total: \$$balancesold",
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controllerNote,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Agrega una nota (Opcional)',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: screenHeight * 0.20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (widget.iddisc == "Nueva Venta") {
                        print("Post: del sale");
                        apiService.postSale(
                            widget.ventaTipo,
                            widget.cantidad,
                            _controllerNote.text,
                            promotion?.data.id ?? 1,
                            widget.idNap,
                            balancesold);

                        final route = MaterialPageRoute(
                          builder: (_) => const MainMenu(),
                        );
                        Navigator.push(context, route);
                      } else if (widget.iddisc == "Editar Venta") {
                        apiService.updateSale(
                            widget.id,
                            widget.ventaTipo,
                            widget.cantidad,
                            _controllerNote.text,
                            promotion?.data.id ?? 0, //Promocion
                            widget.idNap,
                            balancesold);
                        if (widget.ventaTipo == "credito") {
                          final route = MaterialPageRoute(
                              builder: (_) =>
                                  DetailPaymentdata(saleID: widget.id));
                          Navigator.push(context, route);
                        } else if (widget.ventaTipo == "contado") {
                          final route = MaterialPageRoute(
                              builder: (_) => ViewSale(
                                    saleid: widget.id,
                                  ));
                          Navigator.push(context, route);
                        }
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                        iconColor: Colors.black, backgroundColor: Colors.green),
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final route = MaterialPageRoute(
                        builder: (_) => const MainMenu(),
                      );
                      Navigator.push(context, route);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                        iconColor: Colors.black, backgroundColor: Colors.red),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 41, 59),
    );
  }
}
