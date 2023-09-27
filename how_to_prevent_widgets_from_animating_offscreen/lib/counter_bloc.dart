import 'package:bloc/bloc.dart';
import 'package:how_to_prevent_widgets_from_animating_offscreen/value_repository.dart';

enum CounterEvent {
  started;
}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc({
    required ValueRepository valueRepository,
  }) : super(valueRepository.value) {
    on<CounterEvent>(
      (event, emit) => emit.forEach(
        valueRepository.valueStream,
        onData: (newValue) {
          return newValue;
        },
      ),
    );
  }
}
