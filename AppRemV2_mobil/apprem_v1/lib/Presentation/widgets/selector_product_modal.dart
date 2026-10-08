
import 'package:apprem_v1/Presentation/blocs/products/product_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_event.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_state.dart';
import 'package:flutter/material.dart';
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class SelectorProductoModal extends StatefulWidget{

  final Function(Product product, int amount, double unitPrice) onAddProduct;

  const SelectorProductoModal({
    super.key,
    required this.onAddProduct,
  });
  @override
  State<SelectorProductoModal> createState() => _SelectorProductModalState();
}

class _SelectorProductModalState extends State<SelectorProductoModal>{
  Product? _seleccedproduct;
  final TextEditingController _amountController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose(){
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    // Si los productos no están cargados, dispara el evento al abrir el modal
    final productBloc = context.read<ProductBloc>();
    if(productBloc.state is! ProductLoaded)
    {
      productBloc.add(LoadProductsEvent());
    }
  }
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text('Agregar Producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              
              
            ElevatedButton.icon(
          onPressed: ()async{
             await context.pushNamed('products');
             if(context.mounted){
              //Le pides al ProductBloc que refresque el catálogo
             context.read<ProductBloc>().add(LoadProductsEvent());
             }
          }, 
          icon: const Icon(Icons.add),
          label: const Text('Crear'),
          ),

          const SizedBox(height: 8,),
          IconButton(onPressed:()=> Navigator.pop(context), icon: const Icon(Icons.close),),
            ],
          ),
          const SizedBox(height: 16,),
          //Dropdown para elegir producto del catalogo de la DB
         BlocBuilder<ProductBloc, ProductState>(
  builder: (context, state) {
    if (state is ProductLoading || state is ProductInitial) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is ProductLoaded) {
      if(state.products.isEmpty){
        return const Text('No hay productos guardados. Crea uno con el botón "Crear".');
      }
      return DropdownButtonFormField<Product>(
        initialValue: _seleccedproduct,
        hint: const Text('Selecciona un producto'),
        items: state.products.map((prod) {
          return DropdownMenuItem<Product>(
            value: prod,
            child: Text('${prod.nombre} (\$${prod.precioSugerido.toStringAsFixed(2)})'),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            _seleccedproduct = val;
            if (val != null) {
              _priceController.text = val.precioSugerido.toString();
            }
          });
        },
        decoration: const InputDecoration(
          labelText: 'Producto',
          border: OutlineInputBorder(),
        ),
      );
    }

    return const Text('No se pudieron cargar los productos');
  },
),
             const SizedBox(height: 16),
            //Campos para cantidad y precio
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                  ) ,
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      decoration:  const InputDecoration(
                        labelText: 'Precio Unitario',
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                    ),
                    ),
              ],
            ),
            const SizedBox(height: 24,),
            //Boton para confirmar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: (){
                  if(_seleccedproduct == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seleccione un producto'))
                    );
                    return;
                  }
                  final amount = int.tryParse(_amountController.text)?? 1;
                  final price = double.tryParse(_priceController.text) ?? _seleccedproduct!.precioSugerido;

                  //CallBack
                  widget.onAddProduct(_seleccedproduct!, amount, price);
                  Navigator.pop(context);
                },
                 child: const Text('Agregar a la remision', style: TextStyle(fontWeight: FontWeight.bold)),)
                 ),
            
        ],
      ),
      );
  }
}