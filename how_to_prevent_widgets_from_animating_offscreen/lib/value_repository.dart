import 'package:rxdart/rxdart.dart';

class ValueRepository {
  static final ValueRepository instance = ValueRepository._();

  ValueRepository._();

  final _subject = BehaviorSubject.seeded(42);

  int get value => _subject.value;

  set value(int newValue) {
    newValue = newValue.clamp(0, 100);
    if (newValue != value) {
      _subject.value = newValue;
    }
  }

  Stream<int> get valueStream => _subject.stream;
}
