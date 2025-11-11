import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:x10devs/features/flashcard/domain/repositories/ai_generation_repository.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_state.dart';

@lazySingleton
class AiGenerationCubit extends Cubit<AiGenerationState> {
  AiGenerationCubit(this._aiGenerationRepository)
      : super(const AiGenerationState.initial());

  final IAIGenerationRepository _aiGenerationRepository;

  Future<void> generateFlashcards(String text) async {
    emit(const AiGenerationState.loading());
    final result =
        await _aiGenerationRepository.generateFlashcardsFromText(text: text);
    result.fold(
      (failure) => emit(AiGenerationState.error(failure: failure)),
      (candidates) => emit(AiGenerationState.loaded(candidates: candidates)),
    );
  }
}
