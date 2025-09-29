import 'package:flutter/material.dart';
import 'xtextfield.dart';

class XAutoComplete extends StatelessWidget {
  final List<String> suggestions;
  final Function(String)? onSelected;
  const XAutoComplete({super.key, required this.suggestions, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      key: UniqueKey(),
      onSelected: onSelected,

      optionsBuilder: (value){
        if (value.text == '') {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option.toLowerCase().contains(value.text.toLowerCase());
        });
      },

      fieldViewBuilder: (context, controller, focusNode, callback){
        return XTextField(
          controller: controller,
          focusNode: focusNode,
          dense: true,
          verticalContentPadding: 4,
          borderRadius: 10,
          hint: "Type Case Title Here",
        );
      },

      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Material(
          color: Colors.white,
          elevation: 4,
          child: ListView.builder(
            key: UniqueKey(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final option = options.elementAt(index);
              return ListTile(
                title: Text(option),
                onTap: () => onSelected(option),
              );
            },
          ),
        );
      },
    );
  }
}
