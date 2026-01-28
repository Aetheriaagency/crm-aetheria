import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:aetheria_crm/models.dart';
import 'package:aetheria_crm/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final meetingsOnSelectedDay = _selectedDay != null
        ? provider.getMeetingsByDate(_selectedDay!)
        : <Meeting>[];
    
    // Obtener tareas del día seleccionado
    final tasksOnSelectedDay = _selectedDay != null
        ? provider.tasks.where((task) {
            return task.dueDate.year == _selectedDay!.year &&
                   task.dueDate.month == _selectedDay!.month &&
                   task.dueDate.day == _selectedDay!.day;
          }).toList()
        : <Task>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Calendario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Crear Reunión',
            onPressed: () {
              _showCreateMeetingDialog(context, provider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendario fijo en la parte superior
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar<Meeting>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return provider.getMeetingsByDate(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF7B3FF2).withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF7B3FF2),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF3D7BF2),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
              ),
            ),
          ),
          
          // Contenido scrollable: Reuniones y Tareas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Reuniones
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Reuniones del Día',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  if (meetingsOnSelectedDay.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'No hay reuniones programadas para este día',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    )
                  else
                    ...meetingsOnSelectedDay.map((meeting) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: _MeetingCard(
                        meeting: meeting,
                        onTap: () => _showMeetingDetails(context, provider, meeting),
                      ),
                    )),
                  
                  // Separador
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(thickness: 1, height: 1),
                  ),
                  
                  // Sección de Tareas
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Tareas del Día',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  
                  // Tareas pendientes y completadas
                  if (tasksOnSelectedDay.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.task_alt, size: 64, color: Colors.grey[600]),
                            const SizedBox(height: 16),
                            Text(
                              'No hay tareas para este día',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tareas pendientes
                          if (tasksOnSelectedDay.where((t) => !t.isCompleted).isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Pendientes',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9E9E9E)),
                              ),
                            ),
                            ...tasksOnSelectedDay.where((t) => !t.isCompleted).map((task) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: const Color(0xFF242424),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) {
                                    provider.toggleTaskComplete(task.id);
                                  },
                                  activeColor: const Color(0xFF7B3FF2),
                                ),
                                title: Text(
                                  task.title,
                                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                                ),
                                subtitle: task.isFollowUp
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7B3FF2).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Seguimiento 24-48h',
                                          style: TextStyle(fontSize: 11, color: Color(0xFF7B3FF2)),
                                        ),
                                      )
                                    : null,
                              ),
                            )),
                          ],
                          // Tareas completadas
                          if (tasksOnSelectedDay.where((t) => t.isCompleted).isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Completadas',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green),
                              ),
                            ),
                            ...tasksOnSelectedDay.where((t) => t.isCompleted).map((task) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: const Color(0xFF242424).withValues(alpha: 0.5),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) {
                                    provider.toggleTaskComplete(task.id);
                                  },
                                  activeColor: Colors.green,
                                ),
                                title: Text(
                                  task.title,
                                  style: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xFF9E9E9E),
                                  ),
                                ),
                                subtitle: task.isFollowUp
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Seguimiento 24-48h',
                                          style: TextStyle(fontSize: 11, color: Colors.green),
                                        ),
                                      )
                                    : null,
                                trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                              ),
                            )),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateMeetingDialog(BuildContext context, CRMProvider provider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    
    DateTime selectedDate = _selectedDay ?? DateTime.now();
    TimeOfDay selectedStartTime = TimeOfDay.now();
    TimeOfDay selectedEndTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
    String? selectedLeadId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Crear Reunión'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Fecha'),
                    subtitle: Text(DateFormat('d MMMM yyyy', 'es_ES').format(selectedDate)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Hora de inicio'),
                    subtitle: Text(selectedStartTime.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTime,
                      );
                      if (time != null) {
                        setState(() => selectedStartTime = time);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Hora de fin'),
                    subtitle: Text(selectedEndTime.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedEndTime,
                      );
                      if (time != null) {
                        setState(() => selectedEndTime = time);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedLeadId,
                    decoration: const InputDecoration(
                      labelText: 'Lead Relacionado (Opcional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Ninguno')),
                      ...provider.leads.map((lead) => DropdownMenuItem(
                        value: lead.id,
                        child: Text(lead.company),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => selectedLeadId = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                      hintText: 'Oficina, Videollamada, etc.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El título es obligatorio'), backgroundColor: Colors.red),
                  );
                  return;
                }

                final startDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedStartTime.hour,
                  selectedStartTime.minute,
                );

                final endDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedEndTime.hour,
                  selectedEndTime.minute,
                );

                if (endDateTime.isBefore(startDateTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La hora de fin debe ser posterior a la hora de inicio'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final lead = selectedLeadId != null
                    ? provider.allLeads.firstWhere((l) => l.id == selectedLeadId)
                    : null;

                print('🔍 DEBUG - Creando reunión:');
                print('   currentSalesperson (email): ${provider.currentSalesperson}');
                print('   currentSalespersonName: ${provider.currentSalespersonName}');
                
                final meeting = Meeting(
                  id: 'meeting_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  startTime: startDateTime,
                  endTime: endDateTime,
                  assignedTo: provider.currentSalespersonName!, // Usar nombre en vez de email
                  leadId: selectedLeadId,
                  leadName: lead?.company,
                  location: locationController.text.isEmpty ? '' : locationController.text,
                  createdBy: provider.currentSalespersonName!, // Usar nombre en vez de email
                );

                print('📝 Reunión creada:');
                print('   ID: ${meeting.id}');
                print('   Título: ${meeting.title}');
                print('   assignedTo: ${meeting.assignedTo}');
                print('   Fecha/Hora: ${meeting.startTime}');

                provider.addMeeting(meeting);
                
                print('✅ Reunión añadida al provider');
                print('   Total reuniones: ${provider.meetings.length}');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reunión creada exitosamente'), backgroundColor: Colors.green),
                );

                // Actualizar el estado para mostrar la nueva reunión
                this.setState(() {
                  _selectedDay = selectedDate;
                  _focusedDay = selectedDate;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B3FF2)),
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMeetingDetails(BuildContext context, CRMProvider provider, Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(meeting.title)),
            if (!meeting.isCompleted)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteMeeting(meeting.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reunión eliminada'), backgroundColor: Colors.orange),
                  );
                  setState(() {});
                },
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meeting.leadName != null) ...[
              _DetailRow(Icons.business, 'Cliente', meeting.leadName!),
              const SizedBox(height: 12),
            ],
            _DetailRow(Icons.calendar_today, 'Fecha', DateFormat('d MMMM yyyy', 'es_ES').format(meeting.startTime)),
            const SizedBox(height: 12),
            _DetailRow(
              Icons.access_time,
              'Horario',
              '${DateFormat('HH:mm').format(meeting.startTime)} - ${DateFormat('HH:mm').format(meeting.endTime)}',
            ),
            const SizedBox(height: 12),
            if (meeting.location.isNotEmpty) ...[
              _DetailRow(Icons.location_on, 'Ubicación', meeting.location),
              const SizedBox(height: 12),
            ],
            if (meeting.description != null && meeting.description!.isNotEmpty) ...[
              _DetailRow(Icons.description, 'Descripción', meeting.description!),
              const SizedBox(height: 12),
            ],
            _DetailRow(
              Icons.check_circle,
              'Estado',
              meeting.isCompleted ? 'Completada' : 'Pendiente',
            ),
          ],
        ),
        actions: [
          if (!meeting.isCompleted)
            TextButton(
              onPressed: () {
                provider.updateMeetingStatus(meeting.id, true);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reunión marcada como completada'), backgroundColor: Colors.green),
                );
                setState(() {});
              },
              child: const Text('Marcar como Completada'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback onTap;

  const _MeetingCard({required this.meeting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B3FF2), Color(0xFF3D7BF2)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.event, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meeting.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE0E0E0)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('HH:mm').format(meeting.startTime)} - ${DateFormat('HH:mm').format(meeting.endTime)}',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                  ),
                  if (meeting.isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24)
                  else
                    const Icon(Icons.circle_outlined, color: Color(0xFF9E9E9E), size: 24),
                ],
              ),
              if (meeting.leadName != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Color(0xFF9E9E9E)),
                    const SizedBox(width: 8),
                    Text(
                      meeting.leadName!,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ],
              if (meeting.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Color(0xFF9E9E9E)),
                    const SizedBox(width: 8),
                    Text(
                      meeting.location,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF7B3FF2)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
