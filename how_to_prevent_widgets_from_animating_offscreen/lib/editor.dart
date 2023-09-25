import 'package:flutter/material.dart';
import 'package:how_to_prevent_widgets_from_animating_offscreen/business_logic.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({
    super.key,
  });

  void _setCounterValue(strValue) {
    final newValue = int.tryParse(strValue);
    if (newValue != null) {
      BusinessLogic.instance.value = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit value'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set counter value',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 38),
            SizedBox(
              width: 233,
              child: TextField(
                controller: TextEditingController(
                  text: BusinessLogic.instance.value.toString(),
                ),
                onChanged: _setCounterValue,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
