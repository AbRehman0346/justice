extension ListExtension on List{

  List<String> get toListString{
    List<String> linkedCases = [];

    for (var value in this){
      linkedCases.add(value.toString());
    }

    return linkedCases;
  }

}