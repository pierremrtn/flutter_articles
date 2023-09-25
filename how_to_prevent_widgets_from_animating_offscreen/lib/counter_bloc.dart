import 'package:bloc/bloc.dart';
import 'package:how_to_prevent_widgets_from_animating_offscreen/business_logic.dart';

enum CounterEvent {
  started;
}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(BusinessLogic.instance.value) {
    on<CounterEvent>(
      (event, emit) => emit.forEach(
        BusinessLogic.instance.valueStream,
        onData: (newValue) {
          return newValue;
        },
      ),
    );
  }
}
