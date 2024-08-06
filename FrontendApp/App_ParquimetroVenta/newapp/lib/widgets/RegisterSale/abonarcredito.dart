import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureLoginJWT.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/RegisterSale/VIEWpAYMENTDETAIL.dart';

class Abono extends StatefulWidget {
  final int? saleid;
  final String ownerfirst;
  final String ownerlast;
  final String namenap;
  final double credito;
  final double? sumtotal;

  Abono({
    Key? key,
    required this.saleid,
    required this.namenap,
    required this.ownerfirst,
    required this.ownerlast,
    required this.credito,
    required this.sumtotal,
  }) : super(key: key);

  @override
  State<Abono> createState() => _AbonoState();
}

class _AbonoState extends State<Abono> {
  final ApiService apiService = ApiService();
  TextEditingController _controlleramount = TextEditingController();
  TextEditingController _controllernote = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<Operador?> operatorall;

  @override
  void initState() {
    super.initState();
    operatorall = apiService.getOperator();
  }

void _loadData()async{
setState(() {
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
                  builder: (_) =>  DetailPaymentdata(saleID: widget.saleid),
                );
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: SingleChildScrollView(
                child: Container(
                  color: const Color.fromARGB(255, 236, 107, 2),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Abono',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.storefront_outlined,
                              color: Colors.black,
                              size: 80,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.namenap}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  "${widget.ownerfirst} ${widget.ownerlast}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _controlleramount,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        labelText: 'Cantidad',
                        labelStyle: const TextStyle(color: Colors.black),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.monetization_on,
                            color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una cantidad.';
                        }
                        double? amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Por favor ingresa un número válido.';
                        }
                        double sumtotal = widget.sumtotal ?? 0;
                        if (amount > (widget.credito - sumtotal)) {
                          return 'La cantidad max. ${(widget.credito - sumtotal)}.';
                        }
                        return null; // Retorna null si la validación es exitosa
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controllernote,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        labelText: 'Agregar nota (Opcional)',
                        labelStyle: const TextStyle(color: Colors.black),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon:
                            const Icon(Icons.local_offer, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DetailPaymentdata(saleID: widget.saleid),
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
                              transitionDuration: const Duration(
                                  seconds:
                                      1), // Duración de la transición (1 segundo)
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Formulario válido. Procesando datos...')),
                            );
                            print("Se presionó el botón de abonar");
                            apiService.postRegisterPayment(widget.saleid,
                                _controlleramount.text, _controllernote.text);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DetailPaymentdata(
                                  saleID: widget.saleid,
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
                                transitionDuration: const Duration(
                                    seconds:
                                        1), // Duración de la transición (1 segundo)
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Formulario no válido. Corrige los errores.')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Abonar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 211, 211),
    );
  }
}
