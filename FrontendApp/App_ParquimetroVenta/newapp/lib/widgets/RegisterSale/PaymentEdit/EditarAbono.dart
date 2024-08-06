import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/RegisterSale/VIEWpAYMENTDETAIL.dart';

class EditarAbono extends StatefulWidget {
  final int? saleid;
  final int paymentid;
  final double amount;
  final String note;

  EditarAbono({
    Key? key,
    required this.saleid,
    required this.paymentid,
    required this.amount,
    required this.note,
  }) : super(key: key);

  @override
  State<EditarAbono> createState() => _EditarAbonoState();
}

class _EditarAbonoState extends State<EditarAbono> {
  final ApiService apiService = ApiService();
  final TextEditingController _controlleramount = TextEditingController();
  final TextEditingController _controllernote = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores recibidos
    _controlleramount.text = widget.amount.toString();
    _controllernote.text = widget.note;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 10,
        backgroundColor: const Color.fromARGB(255, 20, 36, 63),
        title: const Text(
          'Name Promotor',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 236, 107, 2),
              child: const Center(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Editar el abono aquí',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.attach_money_rounded,
                      size: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                color: const Color.fromARGB(255, 243, 241, 241),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edita el monto del abono',
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controlleramount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        labelText: 'Cantidad',
                        labelStyle: const TextStyle(color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.monetization_on,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controllernote,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        labelText: 'Agregar nota (Opcional)',
                        labelStyle: const TextStyle(color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon:
                            const Icon(Icons.local_offer, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Regresar a la pantalla anterior
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            apiService.putPayment(
                              widget.paymentid,
                              _controlleramount.text,
                              _controllernote.text,
                            );
                            Navigator.pushReplacement(
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
                                transitionDuration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Abonar',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
