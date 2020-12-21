class Pokemon {
  int id;
  //description is the text we see on
  //main screen card text
  String name;

  //When using curly braces { } we note dart that
  //the parameters are optional
  Pokemon({this.id, this.name});


  factory Pokemon.fromDatabaseJson(Map<String, dynamic> data) => Pokemon(
    //Factory method will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Pokemon object

        id: data['id'],
        name: data['name'],

        //Since sqlite doesn't have boolean type for true/false,
        //we will use 0 to denote that it is false
        //and 1 for true
      );

  Map<String, dynamic> toDatabaseJson() => {
    //A method will be used to convert Pokemon objects that
    //are to be stored into the datbase in a form of JSON

        "id": this.id,
        "name": this.name
      };
}
