
import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:flutter/material.dart';

class SelectorClientModal extends StatefulWidget{
  final List<Client> clients;
  final Function(Client client) onClientSelected;

  const SelectorClientModal({
    super.key,
    required this.clients,
    required this.onClientSelected
  });
  @override
  State<SelectorClientModal> createState() => _SelectorClientModalState();
}

class _SelectorClientModalState extends State<SelectorClientModal>{
  String _filter = '';
  @override
  Widget build(BuildContext context){
    //filtro de lista
    final filteredClients = widget.clients.where((c) {
      return c.nombre.toLowerCase().contains(_filter.toLowerCase()) ||
      c.ubicacionCliente.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return Padding(
      //Padding para que el teclado no tape el modal cuando se abra
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
        left: 16,
        right: 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seleccionar Cliente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed:() => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 12,),
          //Buscador
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar por nombre o direccion',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(), 
            ),
            onChanged: (val){
              setState(() {
                _filter = val;
              });
            },
          ),
          const SizedBox(height: 16,),

          //Lista de resultados
          SizedBox(
            height: 250,
            child: filteredClients.isEmpty
            ? const Center(child: Text('No se encontraron clientes'))
            : ListView.separated( 
              itemCount: filteredClients.length,
              separatorBuilder: (_, _) => const Divider(height: 1,), 
              itemBuilder: (context, index){
                final client = filteredClients[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    client.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(client.ubicacionCliente),
                  onTap: () {
                    widget.onClientSelected(client);
                    Navigator.pop(context);
                  },
                );
              }, 
             
              
              ),
          ),

        ],
      ), 
      );
  }
}