class User {
  final int id;
  final String name;
  final String email;

  //positional constructor u need to knw the sequence
  //named constructor that is not the case
  const User({required this.id, required this.name, required this.email});

  //const constructors

  // {}-->named parameters
  User copyWith({int? id, String? name, String? email}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
