import 'package:apprem_v1/Domain/usecases/remission/get_remission_by_id_use_case.dart';
import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_event.dart';
import 'package:apprem_v1/Presentation/blocs/pdfGenerate/pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:apprem_v1/Domain/usecases/remission/generate_pdf_and_share_use_case.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final GeneratePdfAndShareUseCase _generatePdfAndShareUseCase;
  final GetRemissionByIdUseCase _getRemissionByIdUseCase;

  PdfBloc({required GeneratePdfAndShareUseCase generatePdfAndShareUseCase, required GetRemissionByIdUseCase getRemissionByIdUseCase}) : 
  _generatePdfAndShareUseCase = generatePdfAndShareUseCase,
  _getRemissionByIdUseCase = getRemissionByIdUseCase,
  super(PdfInitial()){
    on<GeneratePdfEvent>(_onGeneratePdf);
    on<SharePdfEvent>(_onSharePdf);
  }

  Future<void> _onGeneratePdf(GeneratePdfEvent event, Emitter<PdfState> emit) async{
    emit(PdfLoadingState());
    try{
      //Busca la remision por ID
      final remission = await _getRemissionByIdUseCase(event.remissionId);
      if(remission == null){
        emit(PdfErrorState('No se encontro la remision solicitada'));
        return;
      }
      //Generacion de PDF
      final path = await _generatePdfAndShareUseCase(remission);
      if(path != null){
        emit(PdfSuccessState(path));
      }else{
        emit(const PdfErrorState('No se pudo generar el archivo Pdf'));
      }
    }catch(e){
      emit(PdfErrorState('Erro al generar PDF: $e'));
    }
  }

  Future<void> _onSharePdf(SharePdfEvent event, Emitter<PdfState>emit) async{
    try{
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(event.path)],
          text: 'Adjunto remision'
        )
      );
    }catch(e){
      emit(PdfErrorState('Error al compartir archivo: $e'));
    }
  }
}
