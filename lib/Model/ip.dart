class Ip{
  
  int id;
  String adresseIp;

  // Déclaration du constructeur 
  Ip();

  // Reception de valeur par une map
  void fromMap(Map<String, dynamic> map){
      this.id = map['id'];
      this.adresseIp = map['adresseIp'];
    }

  // Envoie de valeur par une map
    Map<String, dynamic> toMap(){
      Map<String, dynamic> map ={
        'adresseIp': this.adresseIp
      };
      if(id != null) {
        map['id'] = this.id;
      }
      return map;
    }
}