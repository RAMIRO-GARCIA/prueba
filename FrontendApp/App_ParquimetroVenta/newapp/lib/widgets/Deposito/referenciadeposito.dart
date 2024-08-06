import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReferenciaDeposito extends StatefulWidget {
  final void Function(int id, String city)? onCiudadSelected;

  const ReferenciaDeposito({super.key, this.onCiudadSelected});

  @override
  _ReferenciaDepositoState createState() => _ReferenciaDepositoState();
}

class _ReferenciaDepositoState extends State<ReferenciaDeposito> {
  List<Map<String, dynamic>> _ciudades = [];
  Map<String, dynamic>? _ciudadSeleccionada;
  int? idSeleccionado;

  @override
  void initState() {
    super.initState();
    _consultarCiudades();
  }

  Future<void> _consultarCiudades() async {
    var url = Uri.parse('http://192.168.0.107/naps_api/consultaproye.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> parsedList = json.decode(response.body);
        _ciudades = parsedList.map<Map<String, dynamic>>((item) {
          return {
            'ID': int.parse(item['ID']),
            'CITY': item['CITY'] as String,
          };
        }).toList();
      });
    } else {
      throw Exception('Error al cargar las ciudades');
    }
  }

  void _handleCiudadSelected() {
    if (_ciudadSeleccionada != null && widget.onCiudadSelected != null) {
      widget.onCiudadSelected!(
          _ciudadSeleccionada!['ID'] as int, _ciudadSeleccionada!['CITY'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Map<String, dynamic>>(
      value: _ciudadSeleccionada,
      hint: const Text('Seleccione'),
      elevation: 8,
      onChanged: (Map<String, dynamic>? newValue) {
        setState(() {
          _ciudadSeleccionada = newValue;
          idSeleccionado = newValue!['ID'] as int?;
          _handleCiudadSelected(); // 
        });
      },
      items: _ciudades.map<DropdownMenuItem<Map<String, dynamic>>>((ciudad) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: ciudad,
          child: Text('${ciudad['ID']} - ${ciudad['CITY']}'),
        );
      }).toList(),
    );
  }
}