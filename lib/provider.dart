import 'package:flutter/material.dart';
import 'models.dart';

class CRMProvider with ChangeNotifier {
  String? _currentRole;
  String? _currentSalesperson;
  String? _currentSalespersonName;
  String? _espejoSalesperson;

  String? get currentRole => _currentRole;
  String? get currentSalesperson => _currentSalesperson;
  String? get currentSalespersonName => _currentSalespersonName;
  String? get espejoSalesperson => _espejoSalesperson;
  bool get isEspejoMode => _espejoSalesperson != null;

  // Autenticación con email y contraseña
  bool authenticateVendedor(String email, String password) {
    final salesperson = _allSalespersons.firstWhere(
      (s) => s.email == email && s.password == password && s.isActive,
      orElse: () => Salesperson(id: '', name: '', email: '', password: '', team: ''),
    );
    
    if (salesperson.id.isNotEmpty) {
      _currentRole = 'vendedor';
      _currentSalesperson = email;
      _currentSalespersonName = salesperson.name;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ⭐ MEJORADO: Admin puede ser vendedor con permiso especial
  bool authenticateAdmin(String email, String password) {
    // Buscar vendedor con permiso admin
    final admin = _allSalespersons.firstWhere(
      (s) => s.email == email && 
             s.password == password && 
             s.permissions.contains('admin') &&
             s.isActive,
      orElse: () => Salesperson(id: '', name: '', email: '', password: '', team: ''),
    );
    
    if (admin.id.isNotEmpty) {
      _currentRole = 'admin';
      _currentSalesperson = email;
      _currentSalespersonName = admin.name;
      notifyListeners();
      return true;
    }
    
    // Fallback al admin hardcodeado (temporal)
    if (email == 'admin@aetheria.com' && password == 'admin123') {
      _currentRole = 'admin';
      _currentSalesperson = null;
      _currentSalespersonName = 'Administrador';
      notifyListeners();
      return true;
    }
    
    return false;
  }

  void login(String role) {
    _currentRole = role;
    notifyListeners();
  }

  void selectSalesperson(String email) {
    final salesperson = _allSalespersons.firstWhere((s) => s.email == email);
    _currentSalesperson = email;
    _currentSalespersonName = salesperson.name;
    notifyListeners();
  }

  void enterEspejoMode(String salespersonEmail) {
    _espejoSalesperson = salespersonEmail;
    notifyListeners();
  }

  void exitEspejoMode() {
    _espejoSalesperson = null;
    notifyListeners();
  }

  void logout() {
    _currentRole = null;
    _currentSalesperson = null;
    _espejoSalesperson = null;
    notifyListeners();
  }

  // DATA STORE
  List<Lead> _allLeads = [
    Lead(id: '1', company: 'TechStart Solutions', contact: 'María García', email: 'maria@techstart.es', phone: '+34 600 111 222', stage: 'Contactado', amount: 5000, assignedTo: 'David Jiménez', sector: 'Tecnología', teamSize: '15'),
    Lead(id: '2', company: 'Inmobiliaria Del Sol', contact: 'Carlos Ruiz', email: 'carlos@inmobiliaria.com', phone: '+34 600 222 333', stage: 'Reunión Agendada', amount: 8000, assignedTo: 'Iván Jiménez', sector: 'Inmobiliaria', teamSize: '8'),
    Lead(id: '3', company: 'Consultoría Pro', contact: 'Ana Martínez', email: 'ana@consultoria.es', phone: '+34 600 333 444', stage: 'Seguimiento', amount: 12000, assignedTo: 'David Jiménez', sector: 'Consultoría', teamSize: '25'),
    Lead(id: '4', company: 'E-Commerce Moda', contact: 'Laura López', email: 'laura@moda.com', phone: '+34 600 444 555', stage: 'Presupuestado', amount: 15000, assignedTo: 'Iván Jiménez', sector: 'E-commerce', teamSize: '12'),
    Lead(id: '5', company: 'Academia Digital', contact: 'Pedro Sánchez', email: 'pedro@academia.es', phone: '+34 600 555 666', stage: 'Cerrado', amount: 20000, assignedTo: 'David Jiménez', sector: 'Educación', teamSize: '18'),
    Lead(id: '6', company: 'Restaurante Gourmet', contact: 'Sofía Torres', email: 'sofia@restaurante.es', phone: '+34 600 666 777', stage: 'Onboarding', amount: 25000, assignedTo: 'Iván Jiménez', sector: 'Hostelería', teamSize: '20'),
    Lead(id: '7', company: 'Agencia Marketing', contact: 'Roberto Fernández', email: 'roberto@marketing.com', phone: '+34 600 777 888', stage: 'Contactado', amount: 30000, assignedTo: 'David Jiménez', sector: 'Marketing', teamSize: '30'),
    Lead(id: '8', company: 'Clínica Dental', contact: 'Elena Rodríguez', email: 'elena@clinica.es', phone: '+34 600 888 999', stage: 'Reunión Agendada', amount: 10000, assignedTo: 'Iván Jiménez', sector: 'Salud', teamSize: '10'),
    Lead(id: '9', company: 'Transportes Global', contact: 'Miguel Gómez', email: 'miguel@transportes.com', phone: '+34 600 999 000', stage: 'Seguimiento', amount: 18000, assignedTo: 'David Jiménez', sector: 'Logística', teamSize: '50'),
    Lead(id: '10', company: 'Estudio Arquitectura', contact: 'Isabel Moreno', email: 'isabel@arquitectura.es', phone: '+34 600 000 111', stage: 'Presupuestado', amount: 22000, assignedTo: 'Iván Jiménez', sector: 'Arquitectura', teamSize: '12'),
  ];

  List<Task> _allTasks = [
    Task(id: '1', title: 'Llamar para agendar reunión diagnóstico', leadId: '1', assignedTo: 'David Jiménez', dueDate: DateTime.now().add(const Duration(hours: 14))),
    Task(id: '2', title: 'Seguimiento 24h - Cliente en duda', leadId: '5', isFollowUp: true, assignedTo: 'David Jiménez', dueDate: DateTime.now().add(const Duration(hours: 8))),
    Task(id: '3', title: 'Enviar propuesta personalizada', leadId: '2', assignedTo: 'Iván Jiménez', dueDate: DateTime.now().add(const Duration(hours: 16))),
  ];

  List<Team> _allTeams = [
    Team(id: '1', name: 'AetherIA Agency', isActive: true),
  ];

  List<Salesperson> _allSalespersons = [
    Salesperson(id: '1', name: 'David Jiménez', email: 'david@aetheriaagency.es', password: 'david123', phone: '+34 613 52 42 26', team: 'AetherIA Agency', isActive: true, permissions: const ['view_all_leads', 'reassign_leads', 'upload_invoices']),
    Salesperson(id: '2', name: 'Iván Jiménez', email: 'ivan@aetheriaagency.es', password: 'ivan123', phone: '+34 613 52 42 26', team: 'AetherIA Agency', isActive: true, permissions: const ['view_all_leads', 'reassign_leads', 'upload_invoices']),
  ];

  List<Meeting> _allMeetings = [
    Meeting(
      id: '1',
      title: 'Reunión Diagnóstico - TechStart Solutions',
      description: 'Diagnóstico completo de necesidades',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 11)),
      assignedTo: 'David Jiménez',
      leadId: '1',
      leadName: 'TechStart Solutions',
      location: 'Oficina AetherIA',
      status: 'pending', // ⭐ CAMBIO
      createdBy: 'Administrador',
    ),
    Meeting(
      id: '2',
      title: 'Presentación Propuesta - E-Commerce Moda',
      description: 'Presentar propuesta de automatización',
      startTime: DateTime.now().add(const Duration(days: 2, hours: 15)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 16, minutes: 30)),
      assignedTo: 'Iván Jiménez',
      leadId: '4',
      leadName: 'E-Commerce Moda',
      location: 'Videollamada',
      status: 'pending', // ⭐ CAMBIO
      createdBy: 'Administrador',
    ),
  ];

  // GETTERS
  List<Lead> get allLeads => _allLeads;
  List<Team> get allTeams => _allTeams;
  List<Salesperson> get allSalespersons => _allSalespersons;
  
  // ⭐ NUEVO: Ordenar reuniones por hora
  List<Meeting> get allMeetings {
    final sorted = List<Meeting>.from(_allMeetings);
    sorted.sort((a, b) => a.startTime.compareTo(b.startTime));
    return sorted;
  }

  List<Lead> get leads {
    if (_currentRole == 'admin' && !isEspejoMode) return _allLeads;
    final targetSalesperson = isEspejoMode ? _espejoSalesperson : _currentSalespersonName;
    return _allLeads.where((l) => l.assignedTo == targetSalesperson).toList();
  }

  // ⭐ NUEVO: Ordenar tareas por hora de vencimiento
  List<Task> get tasks {
    List<Task> filtered;
    if (_currentRole == 'admin' && !isEspejoMode) {
      filtered = _allTasks;
    } else {
      final targetSalesperson = isEspejoMode ? _espejoSalesperson : _currentSalespersonName;
      filtered = _allTasks.where((t) => t.assignedTo == targetSalesperson).toList();
    }
    // Ordenar por fecha de vencimiento
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return filtered;
  }

  Map<String, int> get stageCount {
    final stages = ['Contactado', 'Reunión Agendada', 'Seguimiento', 'Presupuestado', 'Cerrado', 'Onboarding', 'Lost', 'Ghosting'];
    final count = <String, int>{};
    for (var stage in stages) {
      count[stage] = leads.where((l) => l.stage == stage).length;
    }
    return count;
  }

  // ⭐ NUEVO: Ordenar reuniones por hora
  List<Meeting> get meetings {
    List<Meeting> filtered;
    if (_currentRole == 'admin' && !isEspejoMode) {
      filtered = _allMeetings;
    } else {
      final targetSalesperson = isEspejoMode ? _espejoSalesperson : _currentSalespersonName;
      filtered = _allMeetings.where((m) => m.assignedTo == targetSalesperson).toList();
    }
    // Ordenar por hora de inicio
    filtered.sort((a, b) => a.startTime.compareTo(b.startTime));
    return filtered;
  }

  // ⭐ NUEVO: Obtener reuniones por día ordenadas por hora
  List<Meeting> getMeetingsByDate(DateTime date) {
    final dayMeetings = meetings.where((m) {
      return m.startTime.year == date.year &&
             m.startTime.month == date.month &&
             m.startTime.day == date.day;
    }).toList();
    // Ya están ordenadas por la función meetings
    return dayMeetings;
  }

  // CRUD OPERATIONS - Leads
  void addLead(Lead lead) {
    _allLeads.add(lead);
    notifyListeners();
  }

  // ⭐ NUEVO: Actualizar lead completo (editable por todos)
  void updateLead(Lead updatedLead) {
    final index = _allLeads.indexWhere((l) => l.id == updatedLead.id);
    if (index != -1) {
      _allLeads[index] = updatedLead;
      notifyListeners();
    }
  }

  void updateLeadStage(String leadId, String newStage) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      _allLeads[index] = _allLeads[index].copyWith(stage: newStage);
      
      if (newStage == 'Cerrado') {
        final lead = _allLeads[index];
        _allTasks.add(Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Seguimiento 24h - ${lead.company}',
          leadId: leadId,
          isFollowUp: true,
          assignedTo: lead.assignedTo,
          dueDate: DateTime.now().add(const Duration(hours: 24)),
          description: 'Cliente en duda, realizar seguimiento',
        ));
      }
      
      notifyListeners();
    }
  }

  void updateLeadInfo(
    String leadId, {
    String? company,
    String? contact,
    String? email,
    String? phone,
    String? sector,
    String? teamSize,
    double? amount,
  }) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      _allLeads[index] = _allLeads[index].copyWith(
        company: company ?? _allLeads[index].company,
        contact: contact ?? _allLeads[index].contact,
        email: email ?? _allLeads[index].email,
        phone: phone ?? _allLeads[index].phone,
        sector: sector ?? _allLeads[index].sector,
        teamSize: teamSize ?? _allLeads[index].teamSize,
        amount: amount ?? _allLeads[index].amount,
      );
      print('🔄 Lead actualizado: ${_allLeads[index].company}');
      print('   ID: $leadId');
      notifyListeners();
    } else {
      print('❌ Lead no encontrado: $leadId');
    }
  }

  void addNote(String leadId, String noteText) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: noteText,
        date: DateTime.now(),
        createdBy: _currentSalesperson ?? 'admin',
      );
      _allLeads[index] = lead.copyWith(
        notes: [...lead.notes, note],
      );
      notifyListeners();
    }
  }

  void addActivity(String leadId, String type, String description) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final activity = Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        description: description,
        date: DateTime.now(),
        createdBy: _currentSalesperson ?? 'admin',
      );
      _allLeads[index] = lead.copyWith(
        activities: [...lead.activities, activity],
      );
      notifyListeners();
    }
  }

  void addActivityToLead(String leadId, Activity activity) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      _allLeads[index] = lead.copyWith(
        activities: [...lead.activities, activity],
      );
      notifyListeners();
    }
  }

  void updateActivity(String leadId, String activityId, String newType, String newDescription) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final updatedActivities = lead.activities.map((activity) {
        if (activity.id == activityId) {
          return Activity(
            id: activity.id,
            type: newType,
            description: newDescription,
            date: activity.date,
            createdBy: activity.createdBy,
          );
        }
        return activity;
      }).toList();
      
      _allLeads[index] = lead.copyWith(activities: updatedActivities);
      notifyListeners();
    }
  }

  void deleteActivity(String leadId, String activityId) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final updatedActivities = lead.activities.where((activity) => activity.id != activityId).toList();
      _allLeads[index] = lead.copyWith(activities: updatedActivities);
      notifyListeners();
    }
  }

  void updateNote(String leadId, String noteId, String newText) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final updatedNotes = lead.notes.map((note) {
        if (note.id == noteId) {
          return Note(
            id: note.id,
            text: newText,
            date: note.date,
            createdBy: note.createdBy,
          );
        }
        return note;
      }).toList();
      
      _allLeads[index] = lead.copyWith(notes: updatedNotes);
      notifyListeners();
    }
  }

  void deleteNote(String leadId, String noteId) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      final lead = _allLeads[index];
      final updatedNotes = lead.notes.where((note) => note.id != noteId).toList();
      _allLeads[index] = lead.copyWith(notes: updatedNotes);
      notifyListeners();
    }
  }

  void reassignLead(String leadId, String newAssignee) {
    final index = _allLeads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      _allLeads[index] = _allLeads[index].copyWith(assignedTo: newAssignee);
      notifyListeners();
    }
  }

  Lead? getLeadById(String id) {
    try {
      return _allLeads.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  // Tasks
  void toggleTaskComplete(String taskId) {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _allTasks[index] = _allTasks[index].copyWith(isCompleted: !_allTasks[index].isCompleted);
      notifyListeners();
    }
  }

  void addTask(Task task) {
    _allTasks.add(task);
    notifyListeners();
  }

  // Teams
  void addTeam(Team team) {
    _allTeams.add(team);
    notifyListeners();
  }

  // Salespersons
  void addSalesperson(Salesperson salesperson) {
    _allSalespersons.add(salesperson);
    notifyListeners();
  }

  void toggleSalespersonStatus(String id) {
    final index = _allSalespersons.indexWhere((s) => s.id == id);
    if (index != -1) {
      _allSalespersons[index] = _allSalespersons[index].copyWith(isActive: !_allSalespersons[index].isActive);
      notifyListeners();
    }
  }

  void updateSalespersonStatus(String id, bool isActive) {
    final index = _allSalespersons.indexWhere((s) => s.id == id);
    if (index != -1) {
      _allSalespersons[index] = _allSalespersons[index].copyWith(isActive: isActive);
      notifyListeners();
    }
  }

  // ⭐ NUEVO: Meetings con estados
  void addMeeting(Meeting meeting) {
    _allMeetings.add(meeting);
    notifyListeners();
  }

  // ⭐ NUEVO: Actualizar estado (string en vez de bool)
  void updateMeetingStatus(String meetingId, String newStatus) {
    final index = _allMeetings.indexWhere((m) => m.id == meetingId);
    if (index != -1) {
      _allMeetings[index] = _allMeetings[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void deleteMeeting(String meetingId) {
    _allMeetings.removeWhere((m) => m.id == meetingId);
    notifyListeners();
  }

  Meeting? getMeetingById(String id) {
    try {
      return _allMeetings.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  // GESTIÓN DE FACTURACIÓN
  List<Invoice> _allInvoices = [];
  
  List<Invoice> get allInvoices => _allInvoices;
  
  Map<String, dynamic> calculateSalespersonBilling(String salespersonName, {DateTime? month}) {
    final targetMonth = month ?? DateTime.now();
    
    final closedLeads = _allLeads.where((lead) {
      return lead.assignedTo == salespersonName &&
             lead.stage == 'Cerrado' &&
             lead.createdAt.year == targetMonth.year &&
             lead.createdAt.month == targetMonth.month;
    }).toList();
    
    final totalAmount = closedLeads.fold<double>(0, (sum, lead) => sum + lead.amount);
    
    return {
      'salespersonName': salespersonName,
      'month': targetMonth,
      'closedLeads': closedLeads,
      'closedLeadsCount': closedLeads.length,
      'totalAmount': totalAmount,
    };
  }
  
  List<Map<String, dynamic>> calculateAllSalespersonsBilling({DateTime? month}) {
    final targetMonth = month ?? DateTime.now();
    
    return _allSalespersons.map((salesperson) {
      return calculateSalespersonBilling(salesperson.name, month: targetMonth);
    }).toList();
  }
  
  void addInvoice(Invoice invoice) {
    _allInvoices.add(invoice);
    notifyListeners();
  }
  
  void updateInvoice(String invoiceId, {String? pdfFileName, String? pdfUrl, String? status, String? notes}) {
    final index = _allInvoices.indexWhere((inv) => inv.id == invoiceId);
    if (index != -1) {
      _allInvoices[index] = _allInvoices[index].copyWith(
        pdfFileName: pdfFileName,
        pdfUrl: pdfUrl,
        status: status,
        notes: notes,
      );
      notifyListeners();
    }
  }
  
  List<Invoice> getInvoicesBySalesperson(String salespersonName) {
    return _allInvoices.where((inv) => inv.salespersonName == salespersonName).toList();
  }
  
  List<Invoice> get pendingInvoices {
    return _allInvoices.where((inv) => inv.status == 'Pendiente').toList();
  }
  
  void updateInvoiceStatus(String invoiceId, String newStatus) {
    final index = _allInvoices.indexWhere((inv) => inv.id == invoiceId);
    if (index != -1) {
      final invoice = _allInvoices[index];
      _allInvoices[index] = Invoice(
        id: invoice.id,
        salespersonName: invoice.salespersonName,
        salespersonEmail: invoice.salespersonEmail,
        month: invoice.month,
        totalAmount: invoice.totalAmount,
        closedLeadsCount: invoice.closedLeadsCount,
        pdfFileName: invoice.pdfFileName,
        pdfUrl: invoice.pdfUrl,
        uploadedAt: invoice.uploadedAt,
        status: newStatus,
        notes: invoice.notes,
      );
      notifyListeners();
    }
  }

  void deleteInvoice(String invoiceId) {
    _allInvoices.removeWhere((inv) => inv.id == invoiceId);
    notifyListeners();
  }
}
