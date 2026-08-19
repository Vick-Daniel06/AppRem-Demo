import 'package:apprem_v1/Domain/entities/client.dart';
import 'package:apprem_v1/Domain/entities/product.dart';
import 'package:apprem_v1/Presentation/blocs/clients/client_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/deviceAction/device_action_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/historial/historial_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/products/product_bloc.dart';
import 'package:apprem_v1/Presentation/blocs/remissionForm/remForm_bloc.dart';
import 'package:apprem_v1/Presentation/pages/client_form_screen.dart';
import 'package:apprem_v1/Presentation/pages/client_list_screen.dart';
import 'package:apprem_v1/Presentation/pages/creater_remission_page.dart';
import 'package:apprem_v1/Presentation/pages/historial_page.dart';
import 'package:apprem_v1/Presentation/pages/pdf_preview_page.dart';
import 'package:apprem_v1/Presentation/pages/product_form_screen.dart';
import 'package:apprem_v1/Presentation/pages/product_list_screen.dart';
import 'package:apprem_v1/injection_container.dart' as di;
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter{
  static const String historial = '/';
  static const String createRemission = '/create_rem';
  static const String pdfPreviewPage = '/pdf-preview/:id';
  static const String productFormScreen = '/product_form';
  static const String products = '/products';
  static const String clients = '/clientes';
  static const String clientsFromScreen = '/client_form';

  static final GoRouter router = GoRouter(
    initialLocation: historial,
    routes: [
      GoRoute(
        path: historial,
        name: 'historial',
        builder: (context, state) => BlocProvider(
          create: (_)=> di.sl<HistorialBloc>(),
          child: const HistorialPage(),
          ),
        ),
        GoRoute(
          path: createRemission,
          name: 'crearRemision',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_)=> di.sl<RemformBloc>()),
              BlocProvider(create: (_)=> di.sl<DeviceActionBloc>()),
            ],
             child: const CreaterRemissionPage(),
             ),
          ),
          GoRoute(
            path: pdfPreviewPage,
            name: 'pdfPreview',
            builder: (context, state) {
              final remissionId = state.pathParameters['id']!;
              return BlocProvider(
                create: (context)=> di.sl<PdfBloc>(),
                child: PdfPreviewPage(remissionId: remissionId),
                );
            },

            ),
            
            GoRoute(
              path: products,
              name: 'products',
              builder:(context, state) => BlocProvider(
                create: (_) => di.sl<ProductBloc>(),
                child: const ProductListScreen(),
                ),
              ),

             GoRoute(
              path: productFormScreen,
              name: 'product/form',
              builder: (context, state) {
                final product = state.extra as Product?;
                return BlocProvider(
                  create: (_)=> di.sl<ProductBloc>(),
                  child: ProductFormScreen(productToEdit: product),
                  );
              },
            ),
            GoRoute(
              path: clients,
              name: 'clients',
              builder:(context, state) => BlocProvider(
                create: (_) => di.sl<ClientBloc>(),
                child: const ClientListScreen(),
              ),
              ),
              GoRoute(
                path:clientsFromScreen,
                name: 'client/form',
                builder: (context, state) {
                  final client = state.extra as Client?;
                  return BlocProvider(
                    create: (_) => di.sl<ClientBloc>(),
                    child:  ClientFormScreen(clientToEdit: client,),
                    );
                }, 
                ),
    ]
  );
}