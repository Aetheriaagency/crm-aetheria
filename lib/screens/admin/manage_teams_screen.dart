import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class ManageTeamsScreen extends StatelessWidget {
  const ManageTeamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Equipos y Vendedores'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipos
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Equipos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTeamDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Equipo'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...provider.allTeams.map((team) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.groups, color: Colors.white),
                ),
                title: Text(team.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textLight)),
                subtitle: Text(
                  '${provider.allSalespersons.where((s) => s.teamId == team.id).length} vendedores',
                  style: const TextStyle(color: AppColors.textGray),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: team.isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    team.isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: team.isActive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )).toList(),
            
            const SizedBox(height: 32),

            // Vendedores
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Vendedores',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateSalespersonDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Vendedor'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...provider.allSalespersons.map((salesperson) {
              final leadsCount = provider.allLeads.where((l) => l.assignedTo == salesperson.name).length;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                    child: Text(
                      salesperson.name[0].toUpperCase(),
                      style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(salesperson.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textLight)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(salesperson.email, style: const TextStyle(color: AppColors.textGray)),
                      if (salesperson.phone != null) Text(salesperson.phone!, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('$leadsCount leads asignados', style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: salesperson.isActive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          salesperson.isActive ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            color: salesperson.isActive ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'toggle_status') {
                            provider.updateSalespersonStatus(salesperson.id, !salesperson.isActive);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Estado de ${salesperson.name} actualizado')),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'toggle_status',
                            child: Text(salesperson.isActive ? 'Desactivar' : 'Activar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Crear Nuevo Equipo', style: TextStyle(color: AppColors.textLight)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: const InputDecoration(
            labelText: 'Nombre del Equipo',
            hintText: 'Ej: Equipo Madrid',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final team = Team(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  isActive: true,
                );
                context.read<CRMProvider>().addTeam(team);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Equipo "${team.name}" creado')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showCreateSalespersonDialog(BuildContext context) {
    final provider = context.read<CRMProvider>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedTeamId = provider.allTeams.first.id;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Crear Nuevo Vendedor', style: TextStyle(color: AppColors.textLight)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textLight),
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                style: const TextStyle(color: AppColors.textLight),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                style: const TextStyle(color: AppColors.textLight),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTeamId,
                dropdownColor: AppColors.cardDark,
                style: const TextStyle(color: AppColors.textLight),
                decoration: const InputDecoration(
                  labelText: 'Equipo',
                  border: OutlineInputBorder(),
                ),
                items: provider.allTeams
                    .where((t) => t.isActive)
                    .map((team) => DropdownMenuItem(value: team.id, child: Text(team.name)))
                    .toList(),
                onChanged: (value) {
                  selectedTeamId = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty && emailController.text.trim().isNotEmpty) {
                final salesperson = Salesperson(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                  teamId: selectedTeamId,
                  isActive: true,
                  permissions: ['view_all_leads', 'reassign_leads', 'upload_invoices'],
                );
                provider.addSalesperson(salesperson);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vendedor "${salesperson.name}" creado')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
