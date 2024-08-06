import 'package:flutter/material.dart';
import 'package:newapp/const/login.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/DataStructureDepositList.dart';
import 'package:newapp/widgets/Deposito/EditDeposit/DEPOSITvIEWS.dart';

class BankMoney extends StatefulWidget {
  const BankMoney({super.key});

  @override
  State<BankMoney> createState() => _BankMoneyState();
}

class _BankMoneyState extends State<BankMoney> {
  final ApiService apiService = ApiService();
  Depositslist? depositslist;
  int? storagevalue;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    Depositslist? data = await apiService.getDeposits();
    storagevalue = await SharedPrefsKeys.getStoredValue();
    if (storagevalue != 0) {
      setState(() {
        depositslist = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: depositslist == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: depositslist!.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final deposit = depositslist!.data[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.blue,
                        size: 40,
                      ),
                      title: Text(
                        'Cantidad del deposito: \$${deposit.depositAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        deposit.depositDate.toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.blue),
                      onTap: () {
                        print(
                            "Seleccion del deposito detalle:${deposit.depositId} ");
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DepositViews(idDeposit: deposit.depositId),
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
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
      ),
    );
  }
}
