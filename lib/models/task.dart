import 'organization.dart';

class TaskStatus { //estandard d status (IA ha suggerit millores x tal d'evitar errors d'strings)
  static const String todo = 'TO-DO';
  static const String inProgress = 'In-Progress';
  static const String done = 'DONE';

  static const List<String> values = <String>[
    todo,
    inProgress,
    done,
  ];

  static String normalize(dynamic value) {
    final String normalized = value?.toString().trim().toLowerCase() ?? '';

    if (normalized == 'to-do' || normalized == 'todo' || normalized == 'to do') {
      return todo;
    }

    if (normalized == 'in-progress' ||
        normalized == 'in progress' ||
        normalized == 'in_progress' ||
        normalized == 'progress') {
      return inProgress;
    }

    if (normalized == 'done' ||
        normalized == 'completed' ||
        normalized == 'completado') {
      return done;
    }

    return todo;
  }
}

class Task {
  final String id;
  final String titulo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String status; //afegir camp
  final List<OrganizationUser> usuarios;

  Task({
    required this.id,
    required this.titulo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.status, //q sigui obligatori
    required this.usuarios,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final String id = (json['_id'] ?? json['id'] ?? '').toString();
    final String titulo =
        (json['titulo'] ?? json['title'] ?? 'Sin título').toString();

    return Task(
      id: id,
      titulo: titulo,
      fechaInicio: _parseDate(json['fechaInicio'] ?? json['fecha_inicio']),
      fechaFin: _parseDate(json['fechaFin'] ?? json['fecha_fin']),
      status: TaskStatus.normalize(
        json['status'],
      ),
      usuarios: (json['usuarios'] as List<dynamic>?)
              ?.map((dynamic u) => OrganizationUser.fromJson(u))
              .toList() ??
          [],
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException('Fecha inválida en Task: $value');
  }
}