import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AetheriaCRMApp());
}

// Theme Colors
class AppColors {
  static const Color primaryPurple = Color(0xFF7B3FF2);
  static const Color primaryBlue = Color(0xFF3D7BF2);
  static const Color backgroundDark = Color(0xFF1a1a1a);
  static const Color cardDark = Color(0xFF242424);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textGray = Color(0xFF9E9E9E);
}

// Models
class Lead {
  final String id;
  final String company;
  final String contact;
  final String email;
  final String phone;
  String stage;
  final double amount;
  final String assignedTo;
  String notes;

  Lead({
    required this.id,
    required this.company,
    required this.contact,
    required this.email,
    required this.phone,
    required this.stage,
    required this.amount,
    required this.assignedTo,
    this.notes = '',
  });
}

// Provider
class CRMProvider with ChangeNotifier {
  String? _currentRole;
  String? _currentUser;
  
  final List<Lead> _leads = [
    Lead(id: '1', company: 'TechStart Solutions', contact: 'María García', email: 'maria@techstart.es', phone: '+34 600 111 222', stage: 'Prospección', amount: 5000, assignedTo: 'David Jiménez'),
    Lead(id: '2', company: 'Inmobiliaria Del Sol', contact: 'Carlos Ruiz', email: 'carlos@inmobiliaria.com', phone: '+34 600 222 333', stage: 'Contacto/Agendado', amount: 8000, assignedTo: 'Iván Jiménez'),
    Lead(id: '3', company: 'Consultoría Pro', contact: 'Ana Martínez', email: 'ana@consultoria.es', phone: '+34 600 333 444', stage: 'Diagnóstico', amount: 12000, assignedTo: 'David Jiménez'),
    Lead(id: '4', company: 'E-Commerce Moda', contact: 'Laura López', email: 'laura@moda.com', phone: '+34 600 444 555', stage: 'Propuesta', amount: 15000, assignedTo: 'Iván Jiménez'),
    Lead(id: '5', company: 'Academia Digital', contact: 'Pedro Sánchez', email: 'pedro@academia.es', phone: '+34 600 555 666', stage: 'Cierre', amount: 20000, assignedTo: 'David Jiménez'),
    Lead(id: '6', company: 'Restaurante Gourmet', contact: 'Sofía Torres', email: 'sofia@restaurante.es', phone: '+34 600 666 777', stage: 'Onboarding', amount: 25000, assignedTo: 'Iván Jiménez'),
  ];

  String? get currentRole => _currentRole;
  String? get currentUser => _currentUser;
  
  List<Lead> get leads {
    if (_currentRole == 'admin') return _leads;
    return _leads.where((l) => l.assignedTo == _currentUser).toList();
  }

  void login(String role, String? user) {
    _currentRole = role;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentRole = null;
    _currentUser = null;
    notifyListeners();
  }

  void updateLeadStage(String id, String newStage) {
    final lead = _leads.firstWhere((l) => l.id == id);
    lead.stage = newStage;
    notifyListeners();
  }

  void updateLeadNotes(String id, String notes) {
    final lead = _leads.firstWhere((l) => l.id == id);
    lead.notes = notes;
    notifyListeners();
  }

  void addLead(Lead lead) {
    _leads.add(lead);
    notifyListeners();
  }
}

// Main App
class AetheriaCRMApp extends StatelessWidget {
  const AetheriaCRMApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CRMProvider(),
      child: MaterialApp(
        title: 'AetherIA CRM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.backgroundDark,
          primaryColor: AppColors.primaryPurple,
          cardTheme: CardThemeData(
            color: AppColors.cardDark,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

// Main Screen with everything
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Lead? _selectedLead;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();

    // Login screen
    if (provider.currentRole == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.backgroundDark, Color(0xFF0d0d0d)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.primaryBlue],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 32),
                const Text('AetherIA CRM', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => provider.login('admin', 'Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: const Text('Administrador', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showVendedorSelector(context, provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: const Text('Vendedores', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main CRM Screen
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.currentRole == 'admin' ? 'Panel Administrador' : 'Hola, ${provider.currentUser?.split(' ')[0]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Crear Lead',
            onPressed: () => _showCreateLeadDialog(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              setState(() => _selectedLead = null);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Pipeline (left)
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPIs
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(Icons.business, color: AppColors.primaryPurple, size: 32),
                                const SizedBox(height: 8),
                                Text('${provider.leads.length}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                const Text('Leads Activos', style: TextStyle(color: AppColors.textGray)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(Icons.euro, color: AppColors.primaryPurple, size: 32),
                                const SizedBox(height: 8),
                                Text('€${provider.leads.fold(0.0, (sum, l) => sum + l.amount).toStringAsFixed(0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                const Text('Pipeline', style: TextStyle(color: AppColors.textGray)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Pipeline de Ventas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Pipeline columns
                  SizedBox(
                    height: 500,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var stage in ['Prospección', 'Contacto/Agendado', 'Diagnóstico', 'Propuesta', 'Cierre', 'Onboarding'])
                          _buildStageColumn(stage, provider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lead detail (right)
          if (_selectedLead != null)
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                border: Border(left: BorderSide(color: AppColors.textGray.withValues(alpha: 0.2))),
              ),
              child: _buildLeadDetail(_selectedLead!, provider),
            ),
        ],
      ),
    );
  }

  Widget _buildStageColumn(String stage, CRMProvider provider) {
    final stageLeads = provider.leads.where((l) => l.stage == stage).toList();
    
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text(stage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white24,
                  child: Text('${stageLeads.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: stageLeads.length,
              itemBuilder: (context, index) {
                final lead = stageLeads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedLead = lead);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.company, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(lead.contact, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                          const SizedBox(height: 8),
                          Text('€${lead.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadDetail(Lead lead, CRMProvider provider) {
    final notesController = TextEditingController(text: lead.notes);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Detalles del Lead', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _selectedLead = null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(lead.company, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          const SizedBox(height: 16),
          _InfoRow(Icons.person, 'Contacto', lead.contact),
          _InfoRow(Icons.email, 'Email', lead.email),
          _InfoRow(Icons.phone, 'Teléfono', lead.phone),
          _InfoRow(Icons.euro, 'Monto', '€${lead.amount.toStringAsFixed(0)}'),
          _InfoRow(Icons.person_outline, 'Asignado a', lead.assignedTo),
          const SizedBox(height: 24),
          const Text('Cambiar Etapa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Prospección', 'Contacto/Agendado', 'Diagnóstico', 'Propuesta', 'Cierre', 'Onboarding'].map((stage) {
              final isActive = stage == lead.stage;
              return ElevatedButton(
                onPressed: isActive ? null : () {
                  provider.updateLeadStage(lead.id, stage);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lead movido a $stage'), duration: const Duration(seconds: 1)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppColors.primaryPurple : AppColors.backgroundDark,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(stage, style: const TextStyle(fontSize: 11)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Notas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Añadir notas...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              provider.updateLeadNotes(lead.id, notesController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notas guardadas'), duration: Duration(seconds: 1)),
              );
            },
            icon: const Icon(Icons.save, size: 16),
            label: const Text('Guardar Notas'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
          ),
        ],
      ),
    );
  }

  void _showVendedorSelector(BuildContext context, CRMProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Seleccionar Vendedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Text('D')),
              title: const Text('David Jiménez'),
              onTap: () {
                provider.login('vendedor', 'David Jiménez');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('I')),
              title: const Text('Iván Jiménez'),
              onTap: () {
                provider.login('vendedor', 'Iván Jiménez');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateLeadDialog(BuildContext context, CRMProvider provider) {
    final companyController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    String selectedStage = 'Prospección';
    String selectedAssignee = provider.currentRole == 'admin' ? 'David Jiménez' : provider.currentUser!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Crear Nuevo Lead'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Empresa', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contacto', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monto (€)', border: OutlineInputBorder())),
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
              if (companyController.text.isNotEmpty && contactController.text.isNotEmpty) {
                final lead = Lead(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  company: companyController.text,
                  contact: contactController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  stage: selectedStage,
                  amount: double.tryParse(amountController.text) ?? 0,
                  assignedTo: selectedAssignee,
                );
                provider.addLead(lead);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lead "${lead.company}" creado')),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGray),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
