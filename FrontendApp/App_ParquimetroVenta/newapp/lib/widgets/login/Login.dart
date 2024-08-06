import 'package:flutter/material.dart';
import 'package:newapp/widgets/APIServices/Http.dart';
import 'package:newapp/widgets/Data/DataStructureLoginJWT.dart';
import 'package:newapp/widgets/MainPromotor/MAINmENU.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  int? coderesponse = 0;
  int? idoperator = 0;
  dynamic data;
  LoginJwt? tokens;
  late LoginRequestModel requestModel;
  final ApiService apiService = ApiService();
  String token = "";
  String refreshtoken = "";

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel();
    didChangeDependencies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 6,
            left: MediaQuery.of(context).size.width / 5,
            right: MediaQuery.of(context).size.width / 5,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  // url provicional
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
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Form(
                key: globalFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (input) => requestModel.email = input,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'El email no puede estar vacío';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input)) {
                          return 'Por favor ingresa un email válido';
                        }
                        return null;
                      },
                      controller: _controllerEmail,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(115, 8, 8, 8),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    TextFormField(
                      onSaved: (input) => requestModel.password = input,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'El password no puede estar vacío';
                        } else if (input.length < 2) {
                          return 'El password debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                      controller: _controllerPassword,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(115, 8, 8, 8),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              TextButton(
                onPressed: () async {
                  if (validateAndSave()) {
                    try {
                      LoginJwt? loginJwt = await apiService.postLogin(
                        _controllerEmail.text,
                        _controllerPassword.text,
                      );

                      if (loginJwt != null) {
                        setState(() {
                          tokens = loginJwt;
                          coderesponse = 200;
                        });

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt("walletid", tokens!.wallet);
                        await prefs.setInt("operatorid", tokens!.operatorId);
                        await prefs.setString("token", tokens!.token);
                        await prefs.setString(
                            "refreshtoken", tokens!.refreshToken);

                        // Navegación
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainMenu(),
                          ),
                        );
                      } else {
                        setState(() {
                          coderesponse = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Usuario no válido'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error al iniciar sesión: $e');
                    }
                  } else {
                    print('Error al iniciar sesión');
                  }
                  print("Respuesta tokens::::::${tokens?.token}");
                  print("Respuesta tokens refres::::::${tokens?.refreshToken}");
                  print("El operator_id es ${tokens?.operatorId}");
                  print("El operator_wallet es ${tokens?.wallet}");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(196, 255, 86, 1)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 8)),
                ),
                child: const Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 41, 59),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
