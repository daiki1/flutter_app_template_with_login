class Country {
  final int id;
  final String name;
  final String iso3;
  final String iso2;
  final String phonecode;
  final String capital;
  final String currency;

  Country({
    required this.id,
    required this.name,
    required this.iso3,
    required this.iso2,
    required this.phonecode,
    required this.capital,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      iso3: json['iso3'],
      iso2: json['iso2'],
      phonecode: json['phonecode'],
      capital: json['capital'],
      currency: json['currency'],
    );
  }
}
