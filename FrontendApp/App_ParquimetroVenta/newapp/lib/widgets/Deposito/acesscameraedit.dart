import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryAccess extends StatefulWidget {
  final int buttonText;
  final Function(File) onImageSelected;
  final String? imagePath;

  GalleryAccess(
      {Key? key,
      required this.buttonText,
      required this.onImageSelected,
      this.imagePath})
      : super(key: key);

  @override
  State<GalleryAccess> createState() => _GalleryAccessState();
}

class _GalleryAccessState extends State<GalleryAccess> {
  String texto = "";
  File? galleryFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (widget.buttonText == 1) {
      texto = "Evidencia";
    } else if (widget.buttonText == 2) {
      texto = "Cambiar";
    }
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 34, 178, 230))),
                child: Text(texto,
                    style: const TextStyle(color: Colors.black, fontSize: 17)),
                onPressed: () {
                  _showPicker(context: context);
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200.0,
                width: 200.0,
                child: (widget.buttonText == 2  )
                    ? Center(child: Image.network(widget.imagePath!))
                    : (galleryFile == null
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text('Selecciona o toma una fotografía'),
                            ),
                          )
                        : Center(child: Image.file(galleryFile!))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path);
        widget.onImageSelected(
            galleryFile!); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se ha seleccionado')),
        );
      }
    });
  }
}
