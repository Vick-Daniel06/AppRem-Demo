
import 'dart:io';

import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_event.dart';
import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_state.dart';
import 'package:apprem_v1/Presentation/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatefulWidget {
  final String remissionId;


  const PdfPreviewPage({super.key, required this.remissionId});

  @override
  State<PdfPreviewPage> createState()=> _PdfPreviewPageState();

}

class _PdfPreviewPageState extends State<PdfPreviewPage>{
  @override
  void initState(){
    super.initState();
    //busqueda y generacion enviando el ID
    context.read<PdfBloc>().add(GeneratePdfEvent(widget.remissionId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remission'),
        leading: IconButton(onPressed: ()=> context.go(AppRouter.historial), icon: const Icon(Icons.close)),
      ),
      body: BlocConsumer<PdfBloc, PdfState>(
        listener: (context, state) {
          if(state is PdfErrorState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red,)
            );
          }
        },
        builder: (context, state) {
          if(state is PdfLoadingState || state is PdfInitial){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16,),
                  Text('Gnerando PDF...'),
                ],
              ),
            );
          }
          if(state is PdfSuccessState){
            return Column(
              children: [
                //Ver PDF
                Expanded(
                  child: PdfPreview(
                    build: (format) async => await File(state.path).readAsBytes(),
                    allowPrinting: true,
                    allowSharing: false, 
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    )
                  ),
                  //Barra de acciones
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, -4)
                        )
                      ]
                    ),
                    child: Row(
                      children: [
                        //Boton de salir
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: ()=> context.go(AppRouter.historial), 
                            label: const Text('Terminar'),
                            icon: const Icon(Icons.check_circle_outline),
                            )
                          ),
                          const SizedBox(width: 12,),

                          //Boton para compartir
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: (){
                                context.read<PdfBloc>().add(SharePdfEvent(state.path));
                              }, 
                              icon: const Icon(Icons.share),
                              label: const Text('Compartir'),
                              )
                          ),
                      ],
                    ),
                  ),
              ],
            );
          }
          return const Center(
            child: Text('No se pudo cargar la vista previa del documento'),
          );
        },
        
      ),
      
    );
    
  }
}