class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String telefone;
  final String apartamento;
  final String perfil;
  final bool bloqueado;

  const Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.apartamento,
    required this.perfil,
    this.bloqueado = false,
  });

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? apartamento,
    String? perfil,
    bool? bloqueado,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      apartamento:
          apartamento ?? this.apartamento,
      perfil: perfil ?? this.perfil,
      bloqueado:
          bloqueado ?? this.bloqueado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'apartamento': apartamento,
      'perfil': perfil,
      'bloqueado': bloqueado ? 1 : 0,
    };
  }

  factory Usuario.fromMap(
    Map<String, dynamic> map,
  ) {
    return Usuario(
      id: map['id'] as int?,

      nome:
          map['nome']?.toString() ?? '',

      email:
          map['email']?.toString() ?? '',

      telefone:
          map['telefone']?.toString() ?? '', 

      apartamento:
          map['apartamento']?.toString() ??
              '',

      perfil:
          map['perfil']?.toString() ?? '',

      bloqueado:
          (map['bloqueado'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json,
  ) {
    return Usuario.fromMap(json);
  }

  @override
  String toString() {
    return '''
Usuario(
  id: $id,
  nome: $nome,
  email: $email,
  telefone: $telefone,
  apartamento: $apartamento,
  perfil: $perfil,
  bloqueado: $bloqueado
)
''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Usuario &&
        other.id == id &&
        other.nome == nome &&
        other.email == email &&
        other.telefone == telefone &&
        other.apartamento ==
            apartamento &&
        other.perfil == perfil &&
        other.bloqueado == bloqueado;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      nome,
      email,
      telefone,
      apartamento,
      perfil,
      bloqueado,
    );
  }
}