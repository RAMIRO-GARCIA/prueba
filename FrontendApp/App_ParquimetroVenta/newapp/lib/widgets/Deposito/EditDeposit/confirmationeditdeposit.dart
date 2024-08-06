import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Deposito/EditDeposit/DEPOSITvIEWS.dart';
import 'package:intl/intl.dart';

class ConfirmationDepositEdit extends StatefulWidget {
  final int monthPosition;
  final String monthName;
  final String yearPosition;
  final int referenceDeposit;
  final String amountDeposit;
  final String? UrlImage;
  final int iddeposit;
  final DateTime day;

  ConfirmationDepositEdit({
    super.key,
    required this.monthPosition,
    required this.monthName,
    required this.yearPosition,
    required this.referenceDeposit,
    required this.amountDeposit,
    required this.UrlImage,
    required this.iddeposit,
    required this.day
  });

  @override
  State<ConfirmationDepositEdit> createState() =>
      _ConfirmationDepositEditState();
}

class _ConfirmationDepositEditState extends State<ConfirmationDepositEdit> {
  final ApiService apiService = ApiService();
  final TextEditingController _controllernote = TextEditingController();
  late String formattedDate;
  String? fechaFormateada;
  final _formKey = GlobalKey<FormState>();

  void obtenerFechaActual() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  @override
  void initState() {
    super.initState();
    obtenerFechaActual();
     fechaFormateada = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.day);    
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = screenHeight * 0.1;
    double containerWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 10,
        backgroundColor: const Color.fromARGB(255, 20, 36, 63),
        title: const Text(
          'Name Promotor',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.person, size: 50, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: containerHeight * 0.3,
              vertical: containerWidth * 0.1),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://mybucket-kigo.s3.us-east-2.amazonaws.com/uploads/LOGO-BUTTON.jpg',
                    scale: 1, // Escala de la imagen
                    height: 150, // Altura deseada de la imagen
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 150, // Ancho del contenedor de loading
                        height: 150, // Altura del contenedor de loading
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(), // Indicador de progreso circular
                            SizedBox(height: 10),
                            Text('Cargando'), // Mensaje de carga
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
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Se registro un nuevo deposito por una cantidad de \$${widget.amountDeposit} del periodo de ${widget.monthName} ${widget.yearPosition}',
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ), //Widget para mostrar lo una pequeña descripcion de lo que se esta realizando
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllernote,
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
                  maxLines:
                      null, // Esto permite que el campo de texto se expanda automáticamente
                ), // widget para agregar una nota a la operacion
                const SizedBox(
                  height: 80,
                ),
                SizedBox(height: screenHeight * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        print("id del deposito: ${widget.iddeposit}");
                        print("cantidad del deposito: ${widget.amountDeposit}");
                        print("yeaar del deposito: ${widget.yearPosition}");
                        print("idmes del deposito: ${widget.monthPosition}");
                        print("url del deposito: ${widget.UrlImage}");
                        print("createdate del deposito: ${formattedDate}");
                        apiService.updateDeposit(
                            widget.iddeposit,
                            widget.amountDeposit,
                            widget.yearPosition,
                            widget.monthPosition,
                            widget.UrlImage,
                            widget.referenceDeposit,
                            _controllernote.text,
                            formattedDate,fechaFormateada);

                        final route = MaterialPageRoute(
                          builder: (_) => DepositViews(
                            idDeposit: widget.iddeposit,
                          ),
                        );
                        Navigator.push(context, route);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                          iconColor: Colors.black,
                          backgroundColor: Colors.green),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        final route = MaterialPageRoute(
                          builder: (_) => DepositViews(
                            idDeposit: widget.iddeposit,
                          ),
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
      ),
      backgroundColor:
          const Color.fromARGB(255, 41, 41, 59), // Agrega el color de fondo
    );
  }
}
