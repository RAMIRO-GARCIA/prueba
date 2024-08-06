# Parquímetro Virtual - Registro de Ventas y Depósitos

## Descripción

Esta aplicación está diseñada para el registro de ventas y depósitos enfocados en un parquímetro virtual. Los operadores serán los encargados de realizar estos registros, facilitando la gestión y control de los pagos realizados.

## Instrucciones de Instalación

1. **Descargar el Código**

   Clona el repositorio o descarga el código desde el repositorio de GitHub:

   git clone <URL_DEL_REPOSITORIO>

2. **Modificar la Dirección de Peticiones**

Abre el archivo Http.dart que se encuentra en la carpeta APIServices y modifica la línea donde se define baseUrl para que apunte a la dirección correcta de tu servidor:

final String baseUrl = "http://10.0.2.2:8080"; // Cambia esta línea con tu dirección de servidor

3. **Dependencias**

Asegúrate de tener todas las dependencias necesarias instaladas:
 

flutter pub get




## Compilar la Aplicación a un APK

Para compilar la aplicación en un archivo APK, sigue estos pasos:

1. **Compilar en Modo Release**

Ejecuta el siguiente comando en tu terminal para construir la aplicación en modo release:

flutter build apk --release

2. **Encontrar el APK Generado**

El archivo APK generado se encontrará en la siguiente ruta:

build/app/outputs/flutter-apk/app-release.apk
