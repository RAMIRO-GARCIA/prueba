import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/Data/DataStructureReference.dart';
import 'package:newapp/widgets/Data/DataStructureUrlImage.dart';
import 'package:newapp/widgets/Deposito/EditDeposit/DEPOSITvIEWS.dart';
import 'package:newapp/widgets/Deposito/EditDeposit/confirmationeditdeposit.dart';
import 'package:newapp/widgets/Deposito/acesscameraedit.dart';
import 'package:newapp/widgets/Deposito/months.dart';

class FormEditDeposit extends StatefulWidget {
  final int idDeposit;
  final int year;
  final int month;
  final double monto;
  final int reference;
  final String evidencia;
  final DateTime date;

  FormEditDeposit({
    super.key,
    required this.idDeposit,
    required this.year,
    required this.month,
    required this.monto,
    required this.reference,
    required this.evidencia,
    required this.date,
  });

  @override
  State<FormEditDeposit> createState() => _FormEditDepositState();
}

class _FormEditDepositState extends State<FormEditDeposit> {
  final ApiService apiService = ApiService();
  late Future<Referencias?> referenceFuture;
  Datum? selectedValuereference;
  String? urlupdate;
  Map<String, dynamic>? selectedValue;
  late Future<Referencias?> referenciasbancarias;
  late Future<Operador?> operatorall;
  int? storedValue;

  TextEditingController _controlleryear = TextEditingController();
  TextEditingController _controlleramount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UrlImage? urlImage;
  late int bank;
  List<Datum> references = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    referenceFuture = apiService.getReferences();
    _controlleryear.text = widget.year.toString();
    _controlleramount.text = widget.monto.toString();
    selectedValue = genderItems[widget.month - 1];
    bank = widget.reference;
    urlupdate = widget.evidencia;
    operatorall = apiService.getOperator();

    _loadData();
    //referenciasbancarias = apiService.getReferences();

    didChangeDependencies();
  }

  bool get isFormValid {
    return selectedValue != null &&
        selectedValuereference != null &&
        _controlleryear.text.isNotEmpty &&
        _controlleramount.text.isNotEmpty;
  }

  Future<void> _loadData() async {
    storedValue = await SharedPrefsKeys.getStoredValue();
    if (storedValue != 0) {
      setState(() {
        referenciasbancarias = apiService.getReferences();
        operatorall = apiService.getOperator();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
                  builder: (_) => DepositViews(idDeposit: widget.idDeposit),
                );
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBarLowMain(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.05),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Map<String, dynamic>>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          isDense: true,
                        ),
                        hint: const Center(
                          child: Text(
                            'Mes',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        value: selectedValue,
                        items: genderItems.map((item) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Center(
                              child: Text(
                                '${item['position']}- ${item['name']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona un mes.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            print(
                                "El valor de la selección del mes es: $value");
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _controlleryear,
                        keyboardType: const TextInputType.numberWithOptions(),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Año',
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            prefixIcon:
                                const Icon(Icons.edit_calendar_rounded)),
                        inputFormatters: [
                          //FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}$'),),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,4}$'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<Referencias?>(
                  future: referenceFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var references = snapshot.data!.data;
                      return DropdownButtonFormField<Datum>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          isDense: true,
                        ),
                        hint: const Center(
                          child: Text(
                            'Seleccione una referencia',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        value: selectedValuereference ??
                            references.firstWhere((reference) =>
                                reference.id == widget.reference),
                        items: references.map((Datum reference) {
                          return DropdownMenuItem<Datum>(
                            value: reference,
                            child: Center(
                              child: Text(
                                reference.namebank,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor seleccione una referencia.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            bank = value!.id;
                            selectedValuereference = value;
                            print("La seleccion de banco es :${value.id}");
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            bank = value!.id;
                            selectedValuereference = value;
                          });
                        },
                      );
                    } else {
                      return Center(
                          child: Text('No se encontraron referencias.'));
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controlleramount,
                  keyboardType: const TextInputType.numberWithOptions(),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Monto',
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      prefixIcon: const Icon(Icons.monetization_on_rounded)),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*[\.\,]?\d{0,2}$')),
                  ],
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GalleryAccess(
                  buttonText: 2,
                  onImageSelected: (File imageFile) async {
                    urlImage = await apiService.uploadImageToServer(imageFile);
                    setState(() {
                      urlupdate = urlImage?.url;
                      print("imagen url para guardar: ${urlImage?.url}");
                    });
                  },
                  imagePath: widget.evidencia,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: isFormValid ||
                              urlImage?.url != widget.evidencia
                          ? () {
                              final route = MaterialPageRoute(
                                  builder: (_) => ConfirmationDepositEdit(
                                        monthPosition:
                                            selectedValue?['position'],
                                        monthName: selectedValue?['name'],
                                        yearPosition: _controlleryear.text,
                                        referenceDeposit: bank,
                                        amountDeposit: _controlleramount.text,
                                        UrlImage: urlupdate,
                                        iddeposit: widget.idDeposit,
                                        day: widget.date,
                                      ));
                              Navigator.push(context, route);
                            }
                          : null,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        "Guardar",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                        iconColor: Colors.black,
                        backgroundColor:
                            isFormValid ? Colors.green : Colors.grey,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        final route = MaterialPageRoute(
                          builder: (_) =>
                              DepositViews(idDeposit: widget.idDeposit),
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
      backgroundColor: const Color.fromARGB(255, 243, 241, 241),
    );
  }
}
