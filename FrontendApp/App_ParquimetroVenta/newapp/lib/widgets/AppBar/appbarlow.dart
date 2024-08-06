import 'package:flutter/material.dart';
import 'package:newapp/widgets/Deposito/fORMULARIOrEGISTRObANK.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:newapp/widgets/RegisterSale/FORMULARIOrEGISTERSALE.dart';

class AppBarLowMain extends StatelessWidget {
  const AppBarLowMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 100, // Ajusta la altura del appbar inferior según sea necesario
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MainMenu(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                        seconds: 1), // Duración de la transición (1 segundo)
                  ),
                );
              },
              icon: const Column(
                children: [
                  Icon(Icons.home),
                  Text(
                    'Home',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Column(
                children: [
                  Icon(Icons.shopping_cart),
                  Text(
                    'Venta',
                    style: TextStyle(fontSize: 10),
                  ), // Elimina el fontSize fijo
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const RegisterFormSale(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                        seconds: 1), // Duración de la transición (1 segundo)
                  ),
                );
              },
            ),
            IconButton(
              icon: const Column(
                children: [
                  Icon(Icons.local_atm),
                  Text(
                    'Deposito',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FormsRegisterDeposit(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                        seconds: 1), // Duración de la transición (1 segundo)
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
