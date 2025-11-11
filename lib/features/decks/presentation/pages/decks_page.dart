import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:x10devs/core/widgets/error_display_widget.dart';
import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_cubit.dart';
import 'package:x10devs/features/decks/presentation/bloc/decks_state.dart';
import 'package:x10devs/features/decks/presentation/widgets/decks_list_widget.dart';
import 'package:x10devs/features/decks/presentation/widgets/dialogs/create_or_edit_deck_dialog.dart';
import 'package:x10devs/features/decks/presentation/widgets/empty_decks_view.dart';
import 'package:x10devs/injectable_config.dart';
import 'package:go_router/go_router.dart';

class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  void _showCreateDeckDialog(BuildContext context) async {
    final newName = await showCreateOrEditDeckDialog(context);
    if (newName != null && context.mounted) {
      context.read<DecksCubit>().createDeck(newName);
    }
  }

  @override
  void initState() {
    context.read<DecksCubit>().getDecks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Twoje Talie'),
            actions: [
              ShadButton.ghost(
                child: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
          body: BlocListener<DecksCubit, DecksState>(
            listener: (context, state) {
              state.maybeMap(
                created: (createdState) {
                  context.go('/decks/${createdState.deck.id}');
                  context.read<DecksCubit>().getDecks();
                },
                error: (errorState) {
                  final toaster = ShadToaster.of(context);
                  toaster.show(
                    ShadToast.destructive(
                      title: const Text('Wystąpił błąd'),
                      description: Text(errorState.failure.message),
                    ),
                  );
                },
                orElse: () {},
              );
            },
            child: BlocBuilder<DecksCubit, DecksState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  loading: (_) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  loaded: (loadedState) {
                    if (loadedState.decks.isEmpty) {
                      return EmptyDecksView(
                        onCreateDeckPressed: () =>
                            _showCreateDeckDialog(context),
                      );
                    }
                    return DecksListWidget(decks: loadedState.decks);
                  },
                  created: (_) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (errorState) {
                    return ErrorDisplayWidget(
                      errorMessage: errorState.failure.message,
                      onRetry: () {
                        context.read<DecksCubit>().getDecks();
                      },
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateDeckDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
