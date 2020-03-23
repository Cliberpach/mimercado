class Client{
  String name = '';
  String surname = '';
  String dni = '';
  String email = '';
  String phone = '';
  String token = '';

  toJson() => {
    'name': name,
    'surname': surname,
    'dni': dni,
    'email': email,
    'phone': phone
  };
}