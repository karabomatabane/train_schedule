part of 'saved_schedules_bloc.dart';

sealed class SavedSchedulesState extends Equatable {
  const SavedSchedulesState();

  @override
  List<Object> get props => [];
}

final class SavedSchedulesInitial extends SavedSchedulesState {}

final class SavedSchedulesLoading extends SavedSchedulesState {}

final class SavedSchedulesSuccess extends SavedSchedulesState {
  final List<Schedule> schedules;

  const SavedSchedulesSuccess(this.schedules);

  @override
  List<Object> get props => [schedules];
}

final class SavedSchedulesFailure extends SavedSchedulesState {
  final String message;

  const SavedSchedulesFailure(this.message);

  @override
  List<Object> get props => [message];
}