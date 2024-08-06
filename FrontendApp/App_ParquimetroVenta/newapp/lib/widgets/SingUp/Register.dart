import 'package:flutter/material.dart';
import 'package:newapp/main.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';

class RegisterP extends StatelessWidget {
  const RegisterP({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterUser(),
      backgroundColor: Color.fromARGB(255, 41, 41, 59),
    );
  }
}

class RegisterUser extends StatelessWidget {
  const RegisterUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 160, left: 90, right: 90),
        child: Column(
          children: [
            RegisterNameUser(),
            SizedBox(
              height: 10,
            ),
            RegisterLastNameUser(),
            SizedBox(
              height: 10,
            ),
            RegisterMailUser(),
            SizedBox(
              height: 10,
            ),
            RegisterPhoneUser(),
            SizedBox(
              height: 10,
            ),
            RegisterAreaUser(),
            SizedBox(
              height: 10,
            ),
            RegisterPasswordUser(),
            SizedBox(
              height: 10,
            ),
            RegisterPasswordConfUser(),
            SizedBox(
              height: 10,
            ),
            RegisterBack(),
            SizedBox(
              height: 10,
            ),
            RegisterUserVerify(),
          ],
        ),
      ),
    );
  }
}

class RegisterNameUser extends StatelessWidget {
  const RegisterNameUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Name',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterLastNameUser extends StatelessWidget {
  const RegisterLastNameUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Last Name',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterMailUser extends StatelessWidget {
  const RegisterMailUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Mail',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterPhoneUser extends StatelessWidget {
  const RegisterPhoneUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Phone number',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterAreaUser extends StatelessWidget {
  const RegisterAreaUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Area code',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(
          Icons.code,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterPasswordUser extends StatefulWidget {
  const RegisterPasswordUser({
    super.key,
  });

  @override
  State<RegisterPasswordUser> createState() => _RegisterPasswordUserState();
}

class _RegisterPasswordUserState extends State<RegisterPasswordUser> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      obscureText: _obscureText, // Oculta el texto ingresado
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Password',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // Cambia la visibilidad del texto
              });
            }),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterPasswordConfUser extends StatefulWidget {
  const RegisterPasswordConfUser({
    super.key,
  });

  @override
  State<RegisterPasswordConfUser> createState() =>
      _RegisterPasswordConfUserState();
}

class _RegisterPasswordConfUserState extends State<RegisterPasswordConfUser> {
  bool _obscureText = true;
  @override
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      textAlign: TextAlign.center,
      obscureText: _obscureText, // Oculta el texto ingresado
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(115, 8, 8, 8),
        labelText: 'Confirm password',
        labelStyle: const TextStyle(
            color: Colors.white), // Cambia el color del texto 'User' a blanco
        floatingLabelAlignment: FloatingLabelAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8), //Adelgaza el input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; // Cambia la visibilidad del texto
              });
            }),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterBack extends StatelessWidget {
  const RegisterBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          print('Log In');
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MyApp(),
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
        child: TextField(
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          enabled: false,
          decoration: InputDecoration(
              hintText: 'Go Back',
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: const Color.fromARGB(196, 255, 86, 1),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ));
  }
}

class RegisterUserVerify extends StatelessWidget {
  const RegisterUserVerify({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          print('Register');
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
        child: TextField(
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          enabled: false,
          decoration: InputDecoration(
              hintText: 'Register',
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: const Color.fromARGB(115, 8, 8, 8),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ));
  }
}
