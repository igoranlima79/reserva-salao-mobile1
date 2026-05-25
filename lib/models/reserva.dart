class Reserva {
  final int? id;
  final DateTime data;
  final int usuarioId;

  const Reserva({
    this.id,
    required this.data,
    required this.usuarioId,
  });

  Reserva copyWith({
    int? id,
    DateTime? data,
    int? usuarioId,
  }) {
    return Reserva(
      id: id ?? this.id,
      data: data ?? this.data,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'data': data.toIso8601String(),
        'usuario_id': usuarioId,
      };

  factory Reserva.fromMap(Map<String, dynamic> map) => Reserva(
        id: map['id'] as int?,
        data: DateTime.parse(map['data'] as String),
        usuarioId: map['usuario_id'] as int,
      );

  @override
  String toString() =>
      'Reserva(id: $id, data: $data, usuarioId: $usuarioId)';
}