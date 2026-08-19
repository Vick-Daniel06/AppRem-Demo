import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Presentation/blocs/products/product_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_event.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';


class ProductFormScreen extends StatefulWidget {
  final Product? productToEdit;

  const ProductFormScreen({super.key, this.productToEdit});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _pesoKg;
  late final TextEditingController _priceController;

  bool get _isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.productToEdit?.nombre ?? '',
    );
    _pesoKg = TextEditingController(
      text: widget.productToEdit?.pesoKg.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.productToEdit?.precioSugerido != null
          ? widget.productToEdit!.precioSugerido.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pesoKg.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: _isEditing ? widget.productToEdit!.id : const Uuid().v4(),
        nombre: _nameController.text.trim(),
        pesoKg: double.parse(_pesoKg.text.trim()),
        precioSugerido: double.parse(_priceController.text.trim()),
      );

      context.read<ProductBloc>().add(
        _isEditing
        ? UpdateProductEvent(product)
        : AddProductEvent(product),
      );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        ),
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true); // Regresa a la lista
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ProductLoading;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Producto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.shopping_bag_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa el nombre del producto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pesoKg,
                        enabled: !isLoading,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Peso del producto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.line_weight),
                          
                        ),
                        validator: (value) {
                          if(value == null || value.trim().isEmpty){
                            return 'Porfavor ingrese el peso del producto';
                          }
                          final parsed = double.tryParse(value.trim());
                          if(parsed == null || parsed<0){
                            return 'Ingresa un peso valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        enabled: !isLoading,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Precio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa el precio';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed < 0) {
                            return 'Ingresa un precio válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : () => _onSave(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      
    );
  }
}