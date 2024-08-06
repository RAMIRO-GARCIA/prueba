import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditGallery extends StatefulWidget {
  const EditGallery({super.key});
 
  @override
  State<EditGallery> createState() => _EditGalleryState();
}
 
class _EditGalleryState extends State<EditGallery> {
  File? galleryFile;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
 
    return  Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text('Cambiar',style: TextStyle(color: Colors.black,fontSize: 17),),
                  onPressed: () {
                    _showPicker(context: context);
                  },
                ),  
                const SizedBox(height: 10,),
                 SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: galleryFile == null
                      ?  Center(child: Image.asset('assets/LOGO-BUTTON.jpg',
                              scale: 1, 
                              height: 250, 
                        ),)
                      : Center(child: Image.file(galleryFile!)),
                ),
                
                        
                
              ],
            ),
          );
        },
      );
  }
 
  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
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
 
  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('No se a seleccionado nada')));
        }
      },
    );
  }
}