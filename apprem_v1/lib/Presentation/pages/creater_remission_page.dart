import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_event.dart';
import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_state.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/creator_state.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/remForm_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/remForm_event.dart';
import 'package:apprem_v1/Presentation/widgets/selector_client_modal.dart';
import 'package:apprem_v1/Presentation/widgets/selector_product_modal.dart';
import 'package:apprem_v1/Presentation/widgets/signature_canva.dart';
import 'package:apprem_v1/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreaterRemissionPage extends StatefulWidget {
   const CreaterRemissionPage({super.key});

   @override
   State<CreaterRemissionPage> createState() => _CreaterRemissionPage();
}

class _CreaterRemissionPage extends State<CreaterRemissionPage>{
  String? _fotoPath;
  String? _signaturePath;

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemformBloc>(create: (context) => sl<RemformBloc>()..add(InitializeCreator())),
        BlocProvider<DeviceActionBloc>(create: (context) => sl<DeviceActionBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RemformBloc, RemFormState>(
           listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state){
              
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              if(state.status == FormStatus.saving){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 16,),
                        Text('Guardando remision')
                      ],
                    ),
                    duration: Duration(seconds: 3),
                    )
                );
              }
              if (state.status == FormStatus.success && state.savedRemissionId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Remisión guardada con éxito')),
                );

                context.goNamed(
                  'pdfPreview',
                  pathParameters: {'id': state.savedRemissionId!},
                );
              }
              if(state.status == FormStatus.error && state.errorMessage != null){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red,),
                );
              }
            }
            ),
            BlocListener<DeviceActionBloc, DeviceActionState>(
            
              listener: (context, state) {
                if(state is SuccessFotoProcess){
                  setState(() => _fotoPath = state.fotoPath);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Foto de evidencia adjuntada'), backgroundColor: Colors.blue,),
                  );
                }
                if(state is SuccessSignatureProcess){
                  setState(()=> _signaturePath = state.signaturePath);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Firma del cliente procesada'), backgroundColor: Colors.blue,)
                  );
                }
                if(state is DeviceActionError){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.orange,)
                  );
                }
              },
            )
        ],
        child: Scaffold(
          appBar:AppBar(
            title: BlocBuilder<RemformBloc, RemFormState>(
              builder: (context, state) {
                return Text('Nueva Remisión ${state.folio.isNotEmpty ? "#${state.folio}" : ""}');
              },
            ),
          ),
          body: BlocBuilder<RemformBloc, RemFormState>(
            builder: (context, state){
              if(state.status == FormStatus.catalogsloading){
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSeccionClient(context, state),
                    const Divider(height: 32,),
                    // Seccion B: Productos Añadidos (Tabla/Lista de conceptos)
                    _buildSeccionProducts(context, state),
                    const Divider(height: 32),

                    // Seccion C: Hardware (Captura de Foto y Firma)
                    _buildSeccionHardware(context),
                    const Divider(height: 32),

                    // Seccion D: Totales y Botón de Envío Fuerte
                    _buildSeccionTotalAndSave(context, state),
                  ],
                ),
              );
            }
            ),
        )));
  }

  Widget _buildSeccionClient(BuildContext context, RemFormState state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cliente de la Entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        const SizedBox(height: 8,),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
          leading: const Icon(Icons.person),
          title: Text(state.clientSelected?.nombre ?? 'Seleccione un cliente obligatorio'),
          subtitle: state.clientSelected != null ? Text(state.clientSelected!.ubicacionCliente): null,
          trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
          onTap: () {
            // TODO: Desplegar modal para seleccionar cliente de la lista local
            
              
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder:(modalContext){
                      return SelectorClientModal(
                        clients: state.clientCatalog, 
                        onClientSelected: (client){
                          //Bloc
                          context.read<RemformBloc>().add(
                            ClientsSelected(client),
                          );
                        });
                    } 
                    );
          },
        )
      ],
    );
  }
  Widget _buildSeccionProducts(BuildContext context, RemFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Productos Añadidos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Abrir el selector_producto_modal.dart
                showModalBottomSheet(context: context, 
                isScrollControlled: true, //Para que suba con el teclado
                builder: (modalContext){
                  return SelectorProductoModal(
                    catalog: state.productCatalog, //Los productos cargados de Db
                     onAddProduct: (producto, cantidad, precioUnitario){
                      //El evento BLoC para agregar el renglon y recalcular totales
                      context.read<RemformBloc>().add(
                        ProductAdded(producto, cantidad, precioUnitario),
                      );
                     }
                  );
                }
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.detailLine.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('No hay productos en esta remisión aún.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.detailLine.length,
            itemBuilder: (context, index) {
              final linea = state.detailLine[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(linea.nombreProducto),
                  subtitle: Text('${linea.cantidad} pza(s) x \$${linea.precioUnitarioEnEseMomento.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      context.read<RemformBloc>().add(ProductDeleted(linea.prodctoId));
                    },
                  ),
                
                )
              );
            }
          )
        ]
      ); 
  }

  Widget _buildSeccionHardware(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Evidencias de Entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            // Botón de la Cámara
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(12)),
                onPressed: () {
                  context.read<DeviceActionBloc>().add(TakedFotoEvidance());
                },
                icon: Icon(_fotoPath != null ? Icons.check_circle : Icons.camera_alt, color: _fotoPath != null ? Colors.green : null),
                label: Text(_fotoPath != null ? 'Foto Capturada' : 'Tomar Foto'),
              ),
            ),
            const SizedBox(width: 12),
            // Botón del Lienzo de Firma
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(12)),
                onPressed: () {
                  // TODO: Lanzar el modal o pantalla para que dibuje el dedo
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (modalContext) => SignatureCanva(
                      onCapturedSignature: (bytes){
                        //Evento
                        context.read<DeviceActionBloc>().add(SigantureProcessedController(bytes));
                      }),
                    );
                },
                icon: Icon(_signaturePath != null ? Icons.check_circle : Icons.gesture, color: _signaturePath != null ? Colors.green : null),
                label: Text(_signaturePath != null ? 'Firmado' : 'Firmar Recibido'),
              ),
            ),
          ],
        ),
      ],
    );
  }


Widget _buildSeccionTotalAndSave(BuildContext context, RemFormState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('MONTO TOTAL:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('\$${state.totalamount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: state.status == FormStatus.saving
                ? null
                : () {
                    // Disparamos el guardado enviando las rutas recolectadas por la UI
                    context.read<RemformBloc>().add(
                          SaveRemissionPressed(
                            signaturePath: _signaturePath ?? '', // Será obligatorio por negocio
                            evidanceFotoPath: _fotoPath,
                          ),
                        );

                        
                  },
                  
            child: state.status == FormStatus.saving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('GUARDAR REMISIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }



}