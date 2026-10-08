
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Presentation/blocs/products/product_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_event.dart';
import 'package:apprem_v1/Presentation/blocs/products/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>{

  @override
  void initState(){
    super.initState();
    context.read<ProductBloc>().add(LoadProductsEvent());
  }
  Future<void> _navigateToForm(BuildContext context, {Product? product}) async{
    final result = await context.pushNamed<bool>('product/form', extra: product);

    if(result == true && context.mounted){
      context.read<ProductBloc>().add(LoadProductsEvent());
    }
  }

  void _confirmDelete(BuildContext context, String id){
    showDialog(
      context: context,
       builder: (dialogContextx) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: const Text('Estas seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: ()=> Navigator.pop(dialogContextx), 
            child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: (){
                context.read<ProductBloc>().add(DeleteProductEvent(id));
                Navigator.pop(dialogContextx);
              }, 
              child: const Text('Eliminar', style: TextStyle(color: Colors.red),)
              )
        ],
       )
       );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nuevo Producto',
            onPressed: () => _navigateToForm(context),
          ),
        ],
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
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text('No hay productos registrados aún.'),
              );
            }

            return ListView.separated(
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.shopping_bag_outlined),
                  ),
                  title: Text(
                    product.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    (product.pesoKg == 0)
                        ? 'Sin peso registrado'
                        : '${product.pesoKg} kg',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${product.precioSugerido.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(context, product.id),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToForm(context, product: product),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}