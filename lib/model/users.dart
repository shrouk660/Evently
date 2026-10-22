class Users {
  String? id;
  String? name;
  String? email;
  List<String>? favorites;


  Users({
    this.name,
    this.email,
    this.id,
    this.favorites

  });
  Users.fromFireStore(Map<String,dynamic>? data){
    id = data?["id"];
    name = data?["name"];
    email = data?["email"];
    favorites = List<String>.from(data?["favoriteList"]);

  }
  Map <String,dynamic> toFirStore(){
    return{
      "id" : id,
      "name" : name,
      "email" : email,
      "favoriteList" : favorites


    };

  }

}