import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models.dart';
import '../../provider.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7B3FF2);
  static const Color primaryBlue = Color(0xFF3D7BF2);
  static const Color backgroundDark = Color(0xFF1a1a1a);
  static const Color cardDark = Color(0xFF242424);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textGray = Color(0xFF9E9E9E);
}

class LeadDetailScreen extends StatefulWidget {
  final String leadId;

  const LeadDetailScreen({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final _notesController = TextEditingController();
  final _activityController = TextEditingController();
  String _selectedActivityType = 'Nota';

  @override
  void dispose() {
    _notesController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final lead = provider.getLeadById(widget.leadId);

    if (lead == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lead no encontrado')),
        body: const Center(child: Text('Lead no encontrado')),
      );
    }

    _notesController.text = lead.notes ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(lead.company),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reassign') {
                _showReassignDialog(context, lead);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reassign', child: Text('Reasignar vendedor')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información principal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Empresa', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                              Text(lead.company, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(lead.stage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoItem(Icons.person, 'Contacto', lead.contact),
                        ),
                        Expanded(
                          child: _InfoItem(Icons.email, 'Email', lead.email),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoItem(Icons.phone, 'Teléfono', lead.phone),
                        ),
                        Expanded(
                          child: _InfoItem(Icons.euro, 'Monto Estimado', '€${lead.amount.toStringAsFixed(0)}'),
                        ),
                      ],
                    ),
                    if (lead.sector != null || lead.teamSize != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (lead.sector != null)
                            Expanded(
                              child: _InfoItem(Icons.business_center, 'Sector', lead.sector!),
                            ),
                          if (lead.teamSize != null)
                            Expanded(
                              child: _InfoItem(Icons.people, 'Tamaño Equipo', '${lead.teamSize} personas'),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    _InfoItem(Icons.person_outline, 'Asignado a', lead.assignedTo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cambiar etapa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cambiar Etapa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Contactado', 'Reunión Agendada', 'Seguimiento', 'Presupuestado', 'Cerrado', 'Onboarding', 'Lost', 'Ghosting'].map((stage) {
                        final isCurrentStage = stage == lead.stage;
                        return ElevatedButton(
                          onPressed: isCurrentStage ? null : () {
                            provider.updateLeadStage(lead.id, stage);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lead movido a $stage')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCurrentStage ? AppColors.primaryPurple : AppColors.cardDark,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(stage),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: const TextStyle(color: AppColors.textLight),
                      decoration: const InputDecoration(
                        hintText: 'Añadir notas sobre este lead...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.updateLeadNotes(lead.id, _notesController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notas guardadas')),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Notas'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Añadir actividad
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Registrar Actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedActivityType,
                      dropdownColor: AppColors.cardDark,
                      style: const TextStyle(color: AppColors.textLight),
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Actividad',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Llamada', 'WhatsApp', 'Email', 'Nota', 'Reunión']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedActivityType = value!);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _activityController,
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.textLight),
                      decoration: const InputDecoration(
                        hintText: 'Descripción de la actividad...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_activityController.text.isNotEmpty) {
                          final activity = Activity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            type: _selectedActivityType,
                            description: _activityController.text,
                            createdAt: DateTime.now(),
                            createdBy: provider.currentSalesperson ?? 'Admin',
                          );
                          provider.addActivityToLead(lead.id, activity);
                          _activityController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Actividad registrada')),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Registrar Actividad'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Historial de actividades
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Historial de Actividades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 16),
                    lead.activities.isEmpty
                        ? const Text('No hay actividades registradas', style: TextStyle(color: AppColors.textGray))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lead.activities.length,
                            separatorBuilder: (_, __) => const Divider(height: 24),
                            itemBuilder: (context, index) {
                              final activity = lead.activities[lead.activities.length - 1 - index]; // Más reciente primero
                              return _ActivityItem(activity: activity);
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReassignDialog(BuildContext context, Lead lead) {
    final provider = context.read<CRMProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Reasignar Lead', style: TextStyle(color: AppColors.textLight)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: provider.allSalespersons
              .where((s) => s.isActive)
              .map((salesperson) => ListTile(
                    title: Text(salesperson.name, style: const TextStyle(color: AppColors.textLight)),
                    leading: Radio<String>(
                      value: salesperson.name,
                      groupValue: lead.assignedTo,
                      onChanged: (value) {
                        provider.reassignLead(lead.id, value!);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lead reasignado a $value')),
                        );
                      },
                      activeColor: AppColors.primaryPurple,
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textGray),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 16)),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Activity activity;

  const _ActivityItem({required this.activity});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Llamada':
        return Icons.phone;
      case 'WhatsApp':
        return Icons.chat;
      case 'Email':
        return Icons.email;
      case 'Reunión':
        return Icons.calendar_today;
      default:
        return Icons.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getIconForType(activity.type), size: 20, color: AppColors.primaryPurple),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(activity.type, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textLight)),
                  const Spacer(),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(activity.createdAt),
                    style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(activity.description, style: const TextStyle(color: AppColors.textLight)),
              const SizedBox(height: 4),
              Text('Por: ${activity.createdBy}', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
            ],
          ),
        ),
      ],
    );
  }
}
