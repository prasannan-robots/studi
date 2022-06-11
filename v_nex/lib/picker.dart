import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model.dart';

  Row buildScrollRow(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 150.0,
          child: ElevatedButton(
            child: const Text('Scroll Picker'),
            onPressed: () => showMaterialScrollPicker<PickerModel>(
              context: context,
              title: 'Pick Your City',
              showDivider: false,
              items: ExampleModel.usStates,
              selectedItem: model.selectedUsState,
              onChanged: (value) =>
                  setState(() => model.selectedUsState = value),
              onCancelled: () => print('Scroll Picker cancelled'),
              onConfirmed: () => print('Scroll Picker confirmed'),
            ),
          ),
        ),
        Expanded(
          child: Text(
            '${model.selectedUsState} (${model.selectedUsState.code})',
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
