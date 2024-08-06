import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newapp/widgets/Data/DataStructureNaps.dart';

class ListNaps extends StatefulWidget {
  final int? zoneId;

  ListNaps({this.zoneId, super.key});

  @override
  _ListNapsState createState() => _ListNapsState();
}

class _ListNapsState extends State<ListNaps> {
  List<Nap> _naps = [];
  String selectedNap = ''; // Variable para guardar el valor seleccionado
  final String baseUrl = "http://10.0.2.2:8080";
  Future<void>? _futureList;
  @override
  void initState() {
    super.initState();
    if (widget.zoneId != null) {
     _futureList= getListNaps(widget.zoneId!);
    }
  }

  Future<void> getListNaps(int zoneId) async {
    try {
      var dio = Dio();
      var response = await dio.get("$baseUrl/api/naps/$zoneId/");
      if (response.statusCode == 200) {
        setState(() {
          var data = response.data['data'] as List;
          _naps = data.map<Nap>((item) => Nap.fromJson(item)).toList();
          print("La data del listview de naps es::::: ${_naps.length}");
        });
      } else {
        throw Exception('Error al cargar los NAPs');
      }
    } catch (e) {
      print("Error en la convecion:$e");
    }
  }

  Widget build(BuildContext context) {
    return Expanded(
      child:  ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _naps.length,
              itemBuilder: (BuildContext context, int index) {
                var nap = _naps[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedNap = nap.organizationName;
                      print('Nap $selectedNap');
                    });
                    final snackBar = SnackBar(
                      content: Text('Nap Seleccionado $selectedNap'),
                      action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {},
                        textColor: Colors.white,
                        disabledTextColor: Colors.green,
                        disabledBackgroundColor: Colors.orange,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        nap.organizationName,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
      )
         
    );
  }
}
