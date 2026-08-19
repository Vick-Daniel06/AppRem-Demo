

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class SignatureCanva extends StatefulWidget {
  final Function(Uint8List signaturePath) onCapturedSignature;
  const SignatureCanva({
    super.key,
    required this.onCapturedSignature,
  });

  @override
  State<SignatureCanva> createState() => _SignaturePathState();
}

class _SignaturePathState extends State<SignatureCanva>{
  late SignatureController _controller;
  @override
  void initState(){
    super.initState();
    _controller= SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  Future<void> _saveSignature() async{
    if(_controller.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor solicite la firma antes de guardar'))
      );
      return;
    }
    //Convertir el lienzo a bytes PNG
    final Uint8List? bytes = await _controller.toPngBytes();
    if(bytes != null){

      //Pasa los bytes al callback y cierra el modal
      widget.onCapturedSignature(bytes);
      if(mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Firma de conformidad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 12,),
          //Area tactil para dibujar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.grey.shade200,
              child: Signature(
                controller: _controller,
                height: 200,
                backgroundColor: Colors.grey.shade100,
                ),
            ),
          ),
          const SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => _controller.clear(),
                icon: const Icon(Icons.cleaning_services, color: Colors.red,),
                label: const Text('Limpiar', style: TextStyle(color: Colors.red),),
                ), 
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: _saveSignature, 
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar firma')
                  ),
                ]
                ),
            ],
          )
    
      );
    
  }
}