//Widget para editar las ventas
//Solicita del widget viewsale.dart los datos de la venta que se quiere editar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/AppBar/appbarlow.dart';
import 'package:newapp/widgets/Data/DataStructureNaps.dart';
import 'package:newapp/widgets/Data/DataStructureOperator.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:newapp/widgets/RegisterSale/CONFIRMATIONsAALE.dart';

class FormSaleEdit extends StatefulWidget {
  final int? saleid;
  final double amount;
  final String typesale;
  final int idnap;
  final String namenap;
  final int? tipo;

  FormSaleEdit(
      {super.key,
      required this.saleid,
      required this.amount,
      required this.typesale,
      required this.idnap,
      required this.namenap,
      required this.tipo});

  @override
  _FormSaleEditState createState() => _FormSaleEditState();
}

class _FormSaleEditState extends State<FormSaleEdit> {
  final ApiService apiService = ApiService();
  bool creditoSelected = false;
  bool pagadoSelected = false;
  Nap? listnaps;
  List<Nap> napsList = [];
  List<Nap> filteredNapsList = [];
  late int id;
  late String organizationName;
  String selectedOrganizationName = '';
  int selectedIdNap = 0;
  int selectIdZone = 0;
  String ventaTipo = "";
  late Future<Operador?> operatorall;

  final formKey = GlobalKey<FormState>();
  TextEditingController _controllerCantidad = TextEditingController();
  TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNapsData();

    _filterController.addListener(() {
      filterNapsList();
    });
    _controllerCantidad.text = widget.amount.toString();
    if (widget.tipo == 1) {
      creditoSelected = false;
      pagadoSelected = true;
    } else {
      creditoSelected = true;
      pagadoSelected = false;
    }
    selectedIdNap = widget.idnap;
    ventaTipo = widget.typesale;
    _loadData();
    operatorall = apiService.getOperator();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void fetchNapsData() async {
    List<Nap>? naps = await apiService.getNapsData();
    if (naps != null) {
      setState(() {
        napsList = naps;
        filteredNapsList = naps;
      });
    }
    if (naps != null && naps.length > 2) {
      selectedOrganizationName = widget.namenap;
    } else {
      print('La lista de naps es nula o no tiene suficientes elementos.');
    }
  }

  Future<void> _loadData() async {
    operatorall = apiService.getOperator();
  }

  void filterNapsList() {
    String query = _filterController.text.toLowerCase();
    setState(() {
      filteredNapsList = napsList.where((nap) {
        return nap.organizationName.toLowerCase().contains(query) ||
            nap.zoneName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
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
      bottomNavigationBar: const AppBarLowMain(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: containerHeight * 0.10, vertical: containerWidth * 0.1),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: containerHeight * 0.60,
                    vertical: containerWidth * 0.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _controllerCantidad,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.black), // Color del borde
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    prefixIcon: const Icon(Icons.monetization_on),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*[\.\,]?\d{0,2}$')),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        creditoSelected = true;
                        pagadoSelected = false;
                        ventaTipo = "credito";
                        print("tipo de venta: $ventaTipo");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          creditoSelected ? Colors.red : Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: containerHeight * 0.10,
                        horizontal: containerWidth * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Credito',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        creditoSelected = false;
                        pagadoSelected = true;
                        ventaTipo = "contado";
                        print("tipo de venta: $ventaTipo");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          pagadoSelected ? Colors.green : Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: containerHeight * 0.10,
                        horizontal: containerWidth * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Pagado',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: containerHeight * 0.60,
                    vertical: containerWidth * 0.02),
                child: TextFormField(
                  controller: _filterController,
                  decoration: InputDecoration(
                    labelText: 'Buscar por nombre o zona',
                    labelStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.blueAccent),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredNapsList.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectIdZone = filteredNapsList[index].zoneId;
                          selectedOrganizationName =
                              filteredNapsList[index].organizationName;
                          selectedIdNap = filteredNapsList[index].id;
                          print("ID del NAP: $selectedIdNap");
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.business,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredNapsList[index].organizationName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    filteredNapsList[index].zoneName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Nombre Nap: $selectedOrganizationName',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (selectedIdNap != widget.idnap ||
                          selectedOrganizationName != widget.namenap ||
                          ventaTipo != widget.typesale ||
                          _controllerCantidad.text !=
                                  widget.amount.toString() &&
                              _controllerCantidad.text != "0") {
                        final route = MaterialPageRoute(
                          builder: (_) => ScreenConfirmationSale(
                            id: widget.saleid,
                            organizationName: selectedOrganizationName,
                            idNap: selectedIdNap,
                            ventaTipo: ventaTipo,
                            cantidad: _controllerCantidad.text,
                            idZone: selectIdZone,
                            iddisc: "Editar Venta",
                          ),
                        );
                        Navigator.push(context, route);
                      } else {
                        // Si ninguna variable ha cambiado, muestra un SnackBar
                        const snackBar = SnackBar(
                          content: Text(
                              'Por favor, realice los cambios para continuar.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Guardar",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      iconColor: Colors.black,
                      backgroundColor: selectedIdNap != 0 &&
                              selectedOrganizationName.isNotEmpty &&
                              ventaTipo.isNotEmpty &&
                              _controllerCantidad.text.isNotEmpty
                          ? Colors.green
                          : Colors.grey,
                    ),
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
    );
  }
}
