import 'package:flutter/material.dart';
import 'package:apprem_v1/Domain/entities/product.dart';

class SelectorProductoModal extends StatefulWidget{
  final List<Product> catalog;
  final Function(Product product, int amount, double unitPrice) onAddProduct;

  const SelectorProductoModal({
    super.key,
    required this.catalog,
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
              const Text('Agregar Precio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed:()=> Navigator.pop(context), icon: const Icon(Icons.close),),
            ],
          ),
          const SizedBox(height: 16,),
          //Dropdown para elegir producto del catalogo de la DB
          DropdownButtonFormField<Product>(
            initialValue: _seleccedproduct, //Value: 
            hint: const Text('Selecciona un producto'),
            items: widget.catalog.map((prod) {
              return DropdownMenuItem<Product>(
                value: prod,
                child: Text('${prod.nombre} (\$${prod.precioSugerido.toStringAsFixed(3)})'),
                );
            }).toList(),
             onChanged: (val){
              setState(() {
                _seleccedproduct = val;
                if(val!=null){
                  _priceController.text = val.precioSugerido.toString();
                }
              });
             },
             decoration: const InputDecoration(
              labelText: 'Prodcuto',
              border: OutlineInputBorder(), 
             ),
             ),
             const SizedBox(height: 16),
            //Campos para cantidad y precio
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
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