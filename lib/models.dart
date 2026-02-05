// Models para AetherIA CRM - Versión Optimizada

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

  // ⭐ NUEVO: copyWith completo para edición total
  Lead copyWith({
    String? company,
    String? contact,
    String? email,
    String? phone,
    String? stage,
    double? amount,
    String? assignedTo,
    String? sector,
    String? teamSize,
    List<Note>? notes,
    List<Activity>? activities,
  }) {
    return Lead(
      id: id,
      company: company ?? this.company,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      stage: stage ?? this.stage,
      amount: amount ?? this.amount,
      assignedTo: assignedTo ?? this.assignedTo,
      sector: sector ?? this.sector,
      teamSize: teamSize ?? this.teamSize,
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
  final String password;
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

  Salesperson copyWith({
    bool? isActive,
    String? password,
    String? phone,
  }) {
    return Salesperson(
      id: id,
      name: name,
      email: email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      team: team,
      isActive: isActive ?? this.isActive,
      permissions: permissions,
    );
  }
}

// ⭐ NUEVO: Modelo de reunión con estados
class Meeting {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String assignedTo;
  final String? leadId;
  final String? leadName;
  final String location;
  final List<String> attendees;
  final String status; // ⭐ 'pending', 'completed', 'lost'
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
    this.status = 'pending',
    required this.createdBy,
  });

  Meeting copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? assignedTo,
    String? leadId,
    String? leadName,
    String? location,
    List<String>? attendees,
    String? status,
    String? createdBy,
  }) {
    return Meeting(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      assignedTo: assignedTo ?? this.assignedTo,
      leadId: leadId ?? this.leadId,
      leadName: leadName ?? this.leadName,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // Helpers para estados
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isLost => status == 'lost';
}

class Invoice {
  final String id;
  final String salespersonName;
  final String salespersonEmail;
  final String month;
  final double totalAmount;
  final int closedLeadsCount;
  final String? pdfFileName;
  final String? pdfUrl;
  final DateTime uploadedAt;
  final String status;
  final String? notes;

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
