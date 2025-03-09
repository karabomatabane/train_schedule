import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_form/schedule_form_bloc.dart';
import '../models/form.model.dart';
import '../utils/constants.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key, required this.onSubmit});

  final Function onSubmit;

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController to capture the selected time
  // final TextEditingController _timeController = TextEditingController();

  TimeOfDay? _selectedTime;

  // List of stations to choose from
  final List<String> _stations = <String>[
    'Cape Town',
    'Woodstock',
    'Salt River',
    'Observatory',
    'Mowbray',
    'Rosebank',
    'Rondebosch',
    'Newlands',
    'Claremont',
    'Harfield Rd',
    'Kenilworth',
    'Wynberg',
    'Wittebome',
    'Plumstead',
    'Steurhof',
    'Dieprivier',
    'Heathfield',
    'Retreat',
    'Steenberg',
    'Lakeside',
    'False Bay',
    'Muizenberg',
    'St James',
    'Kalk Bay',
    'Fish Hoek'
  ];

  Future<void> _selectTime(BuildContext context) async {
    // Show time picker dialog
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<ScheduleFormBloc>().add(TimeSelected(picked));
    }
  }

  @override
  void initState() {
    super.initState();

    // Set default values to the first item in the dropdowns
// Set to fourth station
    context.read<ScheduleFormBloc>().add(DepartureStationChanged(4));
// Set to first station
    context.read<ScheduleFormBloc>().add(ArrivalStationChanged(1));
// Set to first day in the list
    context.read<ScheduleFormBloc>().add(TravelDayChanged('Mon-Fri'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleFormBloc, ScheduleFormState>(
      builder: (BuildContext context, ScheduleFormState state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Departure Station Dropdown with index as value
                  DropdownButtonFormField<int>(
                    value: state.selectedDepartureStationIndex,
                    hint: const Text('Select Departure Station'),
                    decoration: InputDecoration(
                      labelText: 'Departure Station',
                      border: OutlineInputBorder(
                        // Outlined border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: List<DropdownMenuItem<int>>.generate(
                        _stations.length, (int index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text(_stations[index]),
                      );
                    }),
                    onChanged: (int? value) {
                      if (value != null) {
                        context
                            .read<ScheduleFormBloc>()
                            .add(DepartureStationChanged(value));
                      }
                    },
                    validator: (int? value) {
                      if (value == null) {
                        return 'Please select a departure station';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0), // Spacing between fields

                  // Arrival Station Dropdown with index as value
                  DropdownButtonFormField<int>(
                    value: state.selectedArrivalStationIndex,
                    hint: const Text('Select Arrival Station'),
                    decoration: InputDecoration(
                      labelText: 'Arrival Station',
                      border: OutlineInputBorder(
                        // Outlined border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: List<DropdownMenuItem<int>>.generate(
                        _stations.length, (int index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text(_stations[index]),
                      );
                    }),
                    onChanged: (int? value) {
                      if (value != null) {
                        context
                            .read<ScheduleFormBloc>()
                            .add(ArrivalStationChanged(value));
                      }
                    },
                    validator: (int? value) {
                      if (value == null) {
                        return 'Please select an arrival station';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0), // Spacing between fields

                  // Travel Day Dropdown
                  DropdownButtonFormField<String>(
                    value: state.selectedTravelDay,
                    hint: const Text('Select Travel Day'),
                    decoration: InputDecoration(
                      labelText: 'Travel Day',
                      border: OutlineInputBorder(
                        // Outlined border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: Constants.travelDays.keys.map((String day) {
                      return DropdownMenuItem<String>(
                        value: Constants.travelDays[day],
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        context
                            .read<ScheduleFormBloc>()
                            .add(TravelDayChanged(value));
                      }
                    },
                    validator: (String? value) {
                      if (value == null) {
                        return 'Please select a travel day';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0), // Spacing between fields

                  // Time TextFormField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          state.selectedTime?.format(context) ?? 'Select Time',
                      border: OutlineInputBorder(
                        // Outlined border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context),
                      ),
                    ),
                    readOnly: true,
                    // Makes the field uneditable
                    onTap: () => _selectTime(context),
                    // Opens the time picker when tapped
                    validator: (String? value) {
                      if (state.selectedTime == null) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24.0), // Spacing before the button

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ScheduleFormData formData = ScheduleFormData(
                          departStation: state.selectedDepartureStationIndex!,
                          arriveStation: state.selectedArrivalStationIndex!,
                          travelDay: state.selectedTravelDay!,
                          searchTime: 'Departure',
                          hours: state.selectedTime!.hour.toString(),
                          minutes: state.selectedTime!.minute.toString(),
                        );
                        widget.onSubmit(formData);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      // Full-width button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
