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

class CreateLeadScreen extends StatefulWidget {
  const CreateLeadScreen({Key? key}) : super(key: key);

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sectorController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedStage = 'Contactado';
  String? _selectedAssignee;

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sectorController.dispose();
    _teamSizeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final salespersons = provider.allSalespersons.where((s) => s.isActive).toList();
    
    // DEBUG: Imprimir información de inicialización
    print('🏗️ BUILD CreateLeadScreen:');
    print('   currentRole: ${provider.currentRole}');
    print('   currentSalesperson (email): ${provider.currentSalesperson}');
    print('   currentSalespersonName: ${provider.currentSalespersonName}');
    print('   _selectedAssignee antes: $_selectedAssignee');
    
    // Usar currentSalespersonName para que coincida con assignedTo del Lead
    _selectedAssignee ??= provider.currentSalespersonName ?? salespersons.first.name;
    
    print('   _selectedAssignee después: $_selectedAssignee');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Información de la empresa
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información de la Empresa',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _companyController,
                            style: const TextStyle(color: AppColors.textLight),
                            decoration: const InputDecoration(
                              labelText: 'Nombre de la Empresa *',
                              prefixIcon: Icon(Icons.business),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre de la empresa es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _sectorController,
                                  style: const TextStyle(color: AppColors.textLight),
                                  decoration: const InputDecoration(
                                    labelText: 'Sector',
                                    prefixIcon: Icon(Icons.business_center),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _teamSizeController,
                                  style: const TextStyle(color: AppColors.textLight),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Tamaño del Equipo',
                                    prefixIcon: Icon(Icons.people),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Información de contacto
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información de Contacto',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _contactController,
                            style: const TextStyle(color: AppColors.textLight),
                            decoration: const InputDecoration(
                              labelText: 'Nombre del Contacto *',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre del contacto es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: AppColors.textLight),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email *',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El email es requerido';
                              }
                              if (!value.contains('@')) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            style: const TextStyle(color: AppColors.textLight),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono *',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El teléfono es requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Configuración del Lead
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Configuración del Lead',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedStage,
                            dropdownColor: AppColors.cardDark,
                            style: const TextStyle(color: AppColors.textLight),
                            decoration: const InputDecoration(
                              labelText: 'Etapa Inicial',
                              prefixIcon: Icon(Icons.timeline),
                              border: OutlineInputBorder(),
                            ),
                            items: ['Contactado', 'Reunión Agendada', 'Seguimiento', 'Presupuestado', 'Cerrado', 'Onboarding', 'Lost', 'Ghosting']
                                .map((stage) => DropdownMenuItem(value: stage, child: Text(stage)))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedStage = value!);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedAssignee,
                            dropdownColor: AppColors.cardDark,
                            style: const TextStyle(color: AppColors.textLight),
                            decoration: const InputDecoration(
                              labelText: 'Asignar a',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            items: salespersons
                                .map((sp) => DropdownMenuItem(value: sp.name, child: Text(sp.name)))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedAssignee = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _amountController,
                            style: const TextStyle(color: AppColors.textLight),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Monto Estimado (€)',
                              prefixIcon: Icon(Icons.euro),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final amount = double.tryParse(value);
                                if (amount == null || amount < 0) {
                                  return 'Ingrese un monto válido';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.textGray.withValues(alpha: 0.3)),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _createLead,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Crear Lead',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createLead() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CRMProvider>();
    
    print('🔍 DEBUG - Creando lead:');
    print('   currentSalesperson: ${provider.currentSalesperson}');
    print('   currentSalespersonName: ${provider.currentSalespersonName}');
    print('   _selectedAssignee: $_selectedAssignee');
    
    final lead = Lead(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      company: _companyController.text.trim(),
      contact: _contactController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      stage: _selectedStage,
      amount: _amountController.text.trim().isEmpty ? 0 : double.tryParse(_amountController.text.trim()) ?? 0,
      assignedTo: _selectedAssignee!,
      sector: _sectorController.text.trim().isEmpty ? '' : _sectorController.text.trim(),
      teamSize: _teamSizeController.text.trim().isEmpty ? '' : _teamSizeController.text.trim(),
    );

    print('📝 Lead creado:');
    print('   ID: ${lead.id}');
    print('   Empresa: ${lead.company}');
    print('   assignedTo: ${lead.assignedTo}');
    print('   Etapa: ${lead.stage}');

    provider.addLead(lead);
    
    print('✅ Lead añadido al provider');
    print('   Total leads en _allLeads: ${provider.allLeads.length}');
    print('   Total leads filtrados para vendedor: ${provider.leads.length}');
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lead "${lead.company}" creado exitosamente'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
