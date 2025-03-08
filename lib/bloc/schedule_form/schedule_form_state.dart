part of 'schedule_form_bloc.dart';

class ScheduleFormState extends Equatable {

  const ScheduleFormState({
    this.selectedDepartureStationIndex,
    this.selectedArrivalStationIndex,
    this.selectedTravelDay,
    this.selectedTime,
  });
  final int? selectedDepartureStationIndex;
  final int? selectedArrivalStationIndex;
  final String? selectedTravelDay;
  final TimeOfDay? selectedTime;

  ScheduleFormState copyWith({
    int? selectedDepartureStationIndex,
    int? selectedArrivalStationIndex,
    String? selectedTravelDay,
    TimeOfDay? selectedTime,
  }) {
    return ScheduleFormState(
      selectedDepartureStationIndex: selectedDepartureStationIndex ?? this.selectedDepartureStationIndex,
      selectedArrivalStationIndex: selectedArrivalStationIndex ?? this.selectedArrivalStationIndex,
      selectedTravelDay: selectedTravelDay ?? this.selectedTravelDay,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    selectedDepartureStationIndex,
    selectedArrivalStationIndex,
    selectedTravelDay,
    selectedTime,
  ];
}

