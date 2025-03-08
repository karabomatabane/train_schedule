import 'package:equatable/equatable.dart';

import '../models/consumable.dart';

class ContentViewState<D extends Equatable, E extends Equatable, N extends Equatable> extends Equatable {
  final bool isLoading;
  final D data;
  final Consumable<E> error;
  final Consumable<N> onNav;

  const ContentViewState({
    required this.isLoading,
    required this.data,
    required this.error,
    required this.onNav,
  });

  ContentViewState.initial({
    required this.isLoading,
    required this.data,
  })  : error = EmptyConsumable<E>(),
        onNav = EmptyConsumable<N>();

  ContentViewState<D, E, N> copyWith({
    bool? isLoading,
    D? data,
    Consumable<E>? error,
    Consumable<N>? onNav,
  }) {
    return ContentViewState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
      onNav: onNav ?? this.onNav,
    );
  }

  @override
  List<Object> get props => [isLoading, data, error, onNav];
}