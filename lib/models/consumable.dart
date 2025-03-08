import 'package:equatable/equatable.dart';

abstract class Consumable<T extends Equatable> extends Equatable {
  const Consumable();

  bool get isConsumed;

  @override
  List<Object> get props => [];
}

class EmptyConsumable<T extends Equatable> extends Consumable<T> {
  const EmptyConsumable();

  @override
  bool get isConsumed => true;
}

class SingleConsumable<T extends Equatable> extends Consumable<T> {
  final T value;
  bool _isConsumed = false;

  SingleConsumable(this.value);

  @override
  bool get isConsumed => _isConsumed;

  void consume() {
    _isConsumed = true;
  }

  @override
  List<Object> get props => [value, _isConsumed];
}