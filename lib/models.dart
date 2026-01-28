// Models para AetherIA CRM

class Lead {
  final String id;
  final String company;
  final String contact;
  final String email;
  final String phone;
  final String stage;
  final double amount;
  final String assignedTo;
  final String sector;
  final String teamSize;
  final DateTime createdAt;
  final List<Note> notes;
  final List<Activity> activities;

  Lead({
    required this.id,
    required this.company,
    required this.contact,
    required this.email,
    required this.phone,
    required this.stage,
    required this.amount,
    required this.assignedTo,
    this.sector = '',
    this.teamSize = '',
    DateTime? createdAt,
    List<Note>? notes,
    List<Activity>? activities,
  })  : createdAt = createdAt ?? DateTime.now(),
        notes = notes ?? [],
        activities = activities ?? [];

  Lead copyWith({
    String? stage,
    double? amount,
    String? assignedTo,
    List<Note>? notes,
    List<Activity>? activities,
  }) {
    return Lead(
      id: id,
      company: company,
      contact: contact,
      email: email,
      phone: phone,
      stage: stage ?? this.stage,
      amount: amount ?? this.amount,
      assignedTo: assignedTo ?? this.assignedTo,
      sector: sector,
      teamSize: teamSize,
      createdAt: createdAt,
      notes: notes ?? this.notes,
      activities: activities ?? this.activities,
    );
  }
}

class Activity {
  final String id;
  final String type; // 'Llamada', 'WhatsApp', 'Email', 'Nota', 'Reunión'
  final String description;
  final DateTime date;
  final String createdBy;

  Activity({
    required this.id,
    required this.type,
    required this.description,
    DateTime? date,
    required this.createdBy,
  }) : date = date ?? DateTime.now();
}

class Note {
  final String id;
  final String text;
  final DateTime date;
  final String createdBy;

  Note({
    required this.id,
    required this.text,
    DateTime? date,
    required this.createdBy,
  }) : date = date ?? DateTime.now();
}

class Task {
  final String id;
  final String title;
  final String leadId;
  final bool isCompleted;
  final bool isFollowUp;
  final String assignedTo;
  final DateTime dueDate;
  final String? description;

  Task({
    required this.id,
    required this.title,
    required this.leadId,
    this.isCompleted = false,
    this.isFollowUp = false,
    required this.assignedTo,
    required this.dueDate,
    this.description,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      leadId: leadId,
      isCompleted: isCompleted ?? this.isCompleted,
      isFollowUp: isFollowUp,
      assignedTo: assignedTo,
      dueDate: dueDate,
      description: description,
    );
  }
}

class Team {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.name,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Salesperson {
  final String id;
  final String name;
  final String email;
  final String password; // Contraseña encriptada (en producción usar hash)
  final String? phone;
  final String team;
  final bool isActive;
  final List<String> permissions;

  Salesperson({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.team,
    this.isActive = true,
    this.permissions = const [],
  });

  Salesperson copyWith({bool? isActive, String? password}) {
    return Salesperson(
      id: id,
      name: name,
      email: email,
      password: password ?? this.password,
      phone: phone,
      team: team,
      isActive: isActive ?? this.isActive,
      permissions: permissions,
    );
  }
}

// Modelo para reuniones de calendario
class Meeting {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String assignedTo; // Nombre del vendedor (no email)
  final String? leadId; // Lead relacionado (opcional)
  final String? leadName; // Nombre del lead para mostrar
  final String location;
  final List<String> attendees;
  final bool isCompleted;
  final String createdBy;

  Meeting({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.assignedTo,
    this.leadId,
    this.leadName,
    this.location = '',
    this.attendees = const [],
    this.isCompleted = false,
    required this.createdBy,
  });

  Meeting copyWith({bool? isCompleted}) {
    return Meeting(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      assignedTo: assignedTo,
      leadId: leadId,
      leadName: leadName,
      location: location,
      attendees: attendees,
      isCompleted: isCompleted ?? this.isCompleted,
      createdBy: createdBy,
    );
  }
}

// Modelo para facturas de agentes
class Invoice {
  final String id;
  final String salespersonName; // Nombre del agente
  final String salespersonEmail; // Email del agente
  final String month; // Mes de facturación (ej: "Enero 2026")
  final double totalAmount; // Total facturado del mes
  final int closedLeadsCount; // Número de leads cerrados
  final String? pdfFileName; // Nombre del archivo PDF
  final String? pdfUrl; // URL del PDF (simulado por ahora)
  final DateTime uploadedAt;
  final String status; // 'Pendiente', 'Subida', 'Pagada'
  final String? notes; // Notas adicionales

  Invoice({
    required this.id,
    required this.salespersonName,
    required this.salespersonEmail,
    required this.month,
    required this.totalAmount,
    required this.closedLeadsCount,
    this.pdfFileName,
    this.pdfUrl,
    DateTime? uploadedAt,
    this.status = 'Pendiente',
    this.notes,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  Invoice copyWith({
    String? pdfFileName,
    String? pdfUrl,
    String? status,
    String? notes,
  }) {
    return Invoice(
      id: id,
      salespersonName: salespersonName,
      salespersonEmail: salespersonEmail,
      month: month,
      totalAmount: totalAmount,
      closedLeadsCount: closedLeadsCount,
      pdfFileName: pdfFileName ?? this.pdfFileName,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      uploadedAt: uploadedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
