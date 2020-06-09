class ScplClient {
  int id;
  int idCitizen;
  int service;
  int category;
  int partner;
  String nameLastname;
  int sum;
  int area;
  int route;
  String address;
  int addressNumber;
  int piso;
  String dpto;
  String cp;
  int dni;
  String cuit;
  String electroral;
  String electoral;
  String telephone;
  String telephoneOne;
  String telephoneTwo;
  String mail;
  String isActive;
  String isSigned;
  int idUserReferrer;
  String signDate;
  
  ScplClient({
    this.id,
    this.idCitizen,
    this.service,
    this.category,
    this.partner,
    this.nameLastname,
    this.sum,
    this.area,
    this.route,
    this.address,
    this.addressNumber,
    this.piso,
    this.dpto,
    this.cp,
    this.dni,
    this.cuit,
    this.electroral,
    this.electoral,
    this.telephone,
    this.telephoneOne,
    this.telephoneTwo,
    this.mail,
    this.isActive,
    this.isSigned,
    this.idUserReferrer,
    this.signDate
  });

  factory ScplClient.fromJson(Map<String, dynamic> json) {
    return ScplClient(
      id: json['id'],
      idCitizen: json['id_citizen'],
      service: json['service'],
      category: json['category'],
      partner: json['partner'],
      nameLastname: json['name_lastname'],
      sum: json['sum'],
      area: json['area'],
      route: json['route'],
      address: json['address'],
      addressNumber: json['address_number'],
      piso: json['piso'],
      dpto: json['dpto'],
      cp: json['cp'],
      dni: json['dni'],
      cuit: json['cuit'],
      electroral: json['electroral'],
      electoral: json['electoral'],
      telephone: json['telephone'],
      telephoneOne: json['telephone_one'],
      telephoneTwo: json['telephone_two'],
      mail: json['mail'],
      isActive: json['is_active'],
      isSigned: json['is_signed'],
      idUserReferrer: json['id_user_referrer'],
      signDate: json['sign_date']
    );
  }

  factory ScplClient.fromString(Map<String, dynamic> json) {
    return ScplClient(
      id: json['id'],
      idCitizen: json['id_citizen'],
      service: json['service'],
      category: json['category'],
      partner: json['partner'],
      nameLastname: json['name_lastname'],
      sum: json['sum'],
      area: json['area'],
      route: json['route'],
      address: json['address'],
      addressNumber: json['address_number'],
      piso: json['piso'],
      dpto: json['dpto'],
      cp: json['cp'],
      dni: json['dni'],
      cuit: json['cuit'],
      electroral: json['electroral'],
      electoral: json['electoral'],
      telephone: json['telephone'],
      telephoneOne: json['telephone_one'],
      telephoneTwo: json['telephone_two'],
      mail: json['mail'],
      isActive: json['is_active'],
      isSigned: json['is_signed'],
      idUserReferrer: json['id_user_referrer'],
      signDate: json['sign_date']
    );
  }

  Map<String, dynamic> toJson() => {
        'id' : id,
        'id_citizen' : idCitizen,
        'service' : service,
        'category' : category,
        'partner' : partner,
        'name_lastname' : nameLastname,
        'sum' : sum,
        'area' : area,
        'route' : route,
        'address' : address,
        'address_number' : addressNumber,
        'piso' : piso,
        'dpto' : dpto,
        'cp' : cp,
        'dni' : dni,
        'cuit' : cuit,
        'electroral' : electroral,
        'electoral' : electoral,
        'telephone' : telephone,
        'telephone_one' : telephoneOne,
        'telephone_two' : telephoneTwo,
        'mail' : mail,
        'is_active' : isActive,
        'is_signed' : isSigned,
        'id_user_referrer' : idUserReferrer,
        'sign_date' : signDate
      };
}
