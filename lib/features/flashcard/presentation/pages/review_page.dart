import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/features/flashcard/data/models/flashcard_candidate_model.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_cubit.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/ai_generation_state.dart';
import 'package:x10devs/features/flashcard/presentation/bloc/flashcard_cubit.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.deckId});

  final String deckId;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final Set<FlashcardCandidateModel> _selectedCandidates = {};
  List<FlashcardCandidateModel> _candidates = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<AiGenerationCubit>().state;
    currentState.whenOrNull(
      loaded: (candidates) {
        _candidates = List.from(candidates);
      },
    );
  }

  void _toggleCandidateSelection(FlashcardCandidateModel candidate) {
    setState(() {
      if (_selectedCandidates.contains(candidate)) {
        _selectedCandidates.remove(candidate);
      } else {
        _selectedCandidates.add(candidate);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedCandidates.addAll(_candidates);
      } else {
        _selectedCandidates.clear();
      }
    });
  }

  void _editCandidate(FlashcardCandidateModel candidate) {
    final frontController = TextEditingController(text: candidate.front);
    final backController = TextEditingController(text: candidate.back);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ShadDialog(
          title: const Text('Edytuj fiszkę'),
          actions: [
            ShadButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ShadButton(
              child: const Text('Zapisz'),
              onPressed: () {
                final newFront = frontController.text;
                final newBack = backController.text;
                if (newFront.isNotEmpty && newBack.isNotEmpty) {
                  setState(() {
                    final index = _candidates.indexOf(candidate);
                    if (index != -1) {
                      _candidates[index] = candidate.copyWith(
                        front: newFront,
                        back: newBack,
                        wasModified: true,
                      );
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          child: Column(
            children: [
              ShadInputFormField(
                placeholder: const Text('Przód'),
                controller: frontController,
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                controller: backController,
                placeholder: const Text('Tył'),
                decoration: const ShadDecoration(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveSelected() {
    if (_selectedCandidates.isEmpty) {
      // Maybe show a snackbar
      return;
    }
    context.read<FlashcardCubit>().createFlashcards(
      deckId: int.parse(widget.deckId),
      candidates: _selectedCandidates.toList(),
    );
    context.go('/decks/${widget.deckId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zatwierdź fiszki'),
        actions: [
          Row(
            children: [
              const Text('Zaznacz wszystko'),
              Checkbox(value: _selectAll, onChanged: (_) => _toggleSelectAll()),
            ],
          ),
          ShadButton(onPressed: _saveSelected, child: const Text('Zapisz')),
        ],
      ),
      body: BlocBuilder<AiGenerationCubit, AiGenerationState>(
        builder: (context, state) {
          return state.when(
            initial: () =>
                const Center(child: Text('Brak wygenerowanych fiszek.')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (initialCandidates) {
              if (_candidates.isEmpty && initialCandidates.isNotEmpty) {
                _candidates = List.from(initialCandidates);
              }
              if (_candidates.isEmpty) {
                return const Center(
                  child: Text('AI nie znalazło żadnych fiszek.'),
                );
              }
              return ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  final isSelected = _selectedCandidates.contains(candidate);
                  return GestureDetector(
                    onTap: () => _toggleCandidateSelection(candidate),
                    child: ShadCard(
                      backgroundColor: candidate.wasModified
                          ? ShadTheme.of(
                              context,
                            ).colorScheme.primary.withAlpha(25)
                          : null,
                      title: Text(candidate.front),
                      description: Text(candidate.back),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShadButton(
                            child: const Icon(Icons.edit),
                            onPressed: () => _editCandidate(candidate),
                          ),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) =>
                                _toggleCandidateSelection(candidate),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (failure) => Center(child: Text('Błąd: ${failure.message}')),
          );
        },
      ),
    );
  }
}
