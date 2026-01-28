import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'provider.dart';
import 'screens/shared/lead_detail_screen.dart';
import 'screens/shared/create_lead_screen.dart';
import 'screens/admin/manage_teams_screen.dart';

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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

// Models
class Lead {
  final String id;
  final String company;
  final String contact;
  final String email;
  final String phone;
  final String stage;
  final double amount;
  final String assignedTo;

  Lead({
    required this.id,
    required this.company,
    required this.contact,
    required this.email,
    required this.phone,
    required this.stage,
    required this.amount,
    required this.assignedTo,
  });
}

class Task {
  final String id;
  final String title;
  final String leadId;
  final bool isCompleted;
  final bool isFollowUp;
  final String assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.leadId,
    this.isCompleted = false,
    this.isFollowUp = false,
    required this.assignedTo,
  });
}

// Provider
class CRMProvider with ChangeNotifier {
  String? _currentRole; // 'admin' or 'vendedor'
  String? _currentSalesperson; // 'David Jiménez' or 'Iván Jiménez'

  String? get currentRole => _currentRole;
  String? get currentSalesperson => _currentSalesperson;

  void login(String role) {
    _currentRole = role;
    notifyListeners();
  }

  void selectSalesperson(String name) {
    _currentSalesperson = name;
    notifyListeners();
  }

  void logout() {
    _currentRole = null;
    _currentSalesperson = null;
    notifyListeners();
  }

  // Mock data
  final List<Lead> _allLeads = [
    Lead(id: '1', company: 'TechStart Solutions', contact: 'María García', email: 'maria@techstart.es', phone: '+34 600 111 222', stage: 'Prospección', amount: 5000, assignedTo: 'David Jiménez'),
    Lead(id: '2', company: 'Inmobiliaria Del Sol', contact: 'Carlos Ruiz', email: 'carlos@inmobiliaria.com', phone: '+34 600 222 333', stage: 'Contacto/Agendado', amount: 8000, assignedTo: 'Iván Jiménez'),
    Lead(id: '3', company: 'Consultoría Pro', contact: 'Ana Martínez', email: 'ana@consultoria.es', phone: '+34 600 333 444', stage: 'Diagnóstico', amount: 12000, assignedTo: 'David Jiménez'),
    Lead(id: '4', company: 'E-Commerce Moda', contact: 'Laura López', email: 'laura@moda.com', phone: '+34 600 444 555', stage: 'Propuesta', amount: 15000, assignedTo: 'Iván Jiménez'),
    Lead(id: '5', company: 'Academia Digital', contact: 'Pedro Sánchez', email: 'pedro@academia.es', phone: '+34 600 555 666', stage: 'Cierre', amount: 20000, assignedTo: 'David Jiménez'),
    Lead(id: '6', company: 'Restaurante Gourmet', contact: 'Sofía Torres', email: 'sofia@restaurante.es', phone: '+34 600 666 777', stage: 'Onboarding', amount: 25000, assignedTo: 'Iván Jiménez'),
    Lead(id: '7', company: 'Agencia Marketing', contact: 'Roberto Fernández', email: 'roberto@marketing.com', phone: '+34 600 777 888', stage: 'Prospección', amount: 30000, assignedTo: 'David Jiménez'),
    Lead(id: '8', company: 'Clínica Dental', contact: 'Elena Rodríguez', email: 'elena@clinica.es', phone: '+34 600 888 999', stage: 'Contacto/Agendado', amount: 10000, assignedTo: 'Iván Jiménez'),
    Lead(id: '9', company: 'Transportes Global', contact: 'Miguel Gómez', email: 'miguel@transportes.com', phone: '+34 600 999 000', stage: 'Diagnóstico', amount: 18000, assignedTo: 'David Jiménez'),
    Lead(id: '10', company: 'Estudio Arquitectura', contact: 'Isabel Moreno', email: 'isabel@arquitectura.es', phone: '+34 600 000 111', stage: 'Propuesta', amount: 22000, assignedTo: 'Iván Jiménez'),
  ];

  final List<Task> _allTasks = [
    Task(id: '1', title: 'Llamar para agendar reunión diagnóstico', leadId: '1', assignedTo: 'David Jiménez'),
    Task(id: '2', title: 'Seguimiento 24h - Cliente en duda', leadId: '5', isFollowUp: true, assignedTo: 'David Jiménez'),
    Task(id: '3', title: 'Enviar propuesta personalizada', leadId: '2', assignedTo: 'Iván Jiménez'),
  ];

  List<Lead> get leads {
    if (_currentRole == 'admin') return _allLeads;
    return _allLeads.where((l) => l.assignedTo == _currentSalesperson).toList();
  }

  List<Task> get tasks {
    if (_currentRole == 'admin') return _allTasks;
    return _allTasks.where((t) => t.assignedTo == _currentSalesperson).toList();
  }

  Map<String, int> get stageCount {
    final stages = ['Prospección', 'Contacto/Agendado', 'Diagnóstico', 'Propuesta', 'Cierre', 'Onboarding'];
    final count = <String, int>{};
    for (var stage in stages) {
      count[stage] = leads.where((l) => l.stage == stage).length;
    }
    return count;
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.backgroundDark, Color(0xFF0d0d0d)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryPurple, AppColors.primaryBlue],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.business, size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'AetherIA CRM',
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.textLight),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sistema de Gestión Comercial',
                      style: TextStyle(fontSize: 18, color: AppColors.textGray),
                    ),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          _LoginButton(
                            label: 'Administrador',
                            icon: Icons.admin_panel_settings,
                            onPressed: () {
                              context.read<CRMProvider>().login('admin');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const AdminDashboard()),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _LoginButton(
                            label: 'Vendedores',
                            icon: Icons.people,
                            onPressed: () {
                              context.read<CRMProvider>().login('vendedor');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const SalespersonSelector()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _LoginButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.primaryPurple.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Salesperson Selector
class SalespersonSelector extends StatelessWidget {
  const SalespersonSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Vendedor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<CRMProvider>().logout();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _SalespersonCard(
                name: 'David Jiménez',
                email: 'david@aetheriaagency.es',
                onTap: () {
                  context.read<CRMProvider>().selectSalesperson('David Jiménez');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const VendedorDashboard()));
                },
              ),
              _SalespersonCard(
                name: 'Iván Jiménez',
                email: 'ivan@aetheriaagency.es',
                onTap: () {
                  context.read<CRMProvider>().selectSalesperson('Iván Jiménez');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const VendedorDashboard()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalespersonCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onTap;

  const _SalespersonCard({required this.name, required this.email, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryPurple.withOpacity(0.2),
                child: Text(name[0], style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textLight), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(email, style: const TextStyle(fontSize: 14, color: AppColors.textGray), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// Vendedor Dashboard  
class VendedorDashboard extends StatelessWidget {
  const VendedorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final salesperson = provider.currentSalesperson!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${salesperson.split(' ')[0]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _KPICard('Leads Activos', provider.leads.length.toString(), Icons.business)),
                const SizedBox(width: 16),
                Expanded(child: _KPICard('Tareas Pendientes', provider.tasks.where((t) => !t.isCompleted).length.toString(), Icons.task)),
                const SizedBox(width: 16),
                Expanded(child: _KPICard('Seguimientos 24-48h', provider.tasks.where((t) => t.isFollowUp).length.toString(), Icons.access_time)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Pipeline de Ventas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _StageColumn('Prospección', provider),
                  _StageColumn('Contacto/Agendado', provider),
                  _StageColumn('Diagnóstico', provider),
                  _StageColumn('Propuesta', provider),
                  _StageColumn('Cierre', provider),
                  _StageColumn('Onboarding', provider),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tareas de Hoy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
            const SizedBox(height: 16),
            ...provider.tasks.map((task) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Checkbox(value: task.isCompleted, onChanged: (_) {}, activeColor: AppColors.primaryPurple),
                title: Text(task.title, style: const TextStyle(color: AppColors.textLight)),
                subtitle: task.isFollowUp ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Seguimiento 24-48h', style: TextStyle(fontSize: 11, color: AppColors.primaryPurple)),
                ) : null,
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _KPICard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryPurple),
                const Spacer(),
                Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textLight)),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGray)),
          ],
        ),
      ),
    );
  }
}

class _StageColumn extends StatelessWidget {
  final String stage;
  final CRMProvider provider;

  const _StageColumn(this.stage, this.provider);

  @override
  Widget build(BuildContext context) {
    final stageLeads = provider.leads.where((l) => l.stage == stage).toList();
    
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text(stage, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white24,
                  child: Text(stageLeads.length.toString(), style: const TextStyle(fontSize: 12, color: Colors.white)),
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
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead.company, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Text(lead.contact, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                        const SizedBox(height: 8),
                        Text('€${lead.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                      ],
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
}

// Admin Dashboard
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Insights del Negocio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _AdminKPICard('Total Leads', provider._allLeads.length.toString(), Icons.business)),
                const SizedBox(width: 16),
                Expanded(child: _AdminKPICard('Conversión Global', '${((provider._allLeads.where((l) => l.stage == 'Onboarding').length / provider._allLeads.length) * 100).toStringAsFixed(1)}%', Icons.trending_up)),
                const SizedBox(width: 16),
                Expanded(child: _AdminKPICard('Pipeline Total', '€${provider._allLeads.fold(0.0, (sum, l) => sum + l.amount).toStringAsFixed(0)}', Icons.euro)),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Embudo de Conversión', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 24),
                    ...provider.stageCount.entries.map((entry) {
                      final maxCount = provider.stageCount.values.reduce((a, b) => a > b ? a : b);
                      final percentage = maxCount > 0 ? (entry.value / maxCount) : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLight)),
                                Text(entry.value.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                backgroundColor: AppColors.backgroundDark,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gestión de Vendedores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Text('D', style: TextStyle(color: Colors.white))),
                      title: const Text('David Jiménez', style: TextStyle(color: AppColors.textLight)),
                      subtitle: Text('${provider._allLeads.where((l) => l.assignedTo == 'David Jiménez').length} leads asignados', style: const TextStyle(color: AppColors.textGray)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Activo', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const Divider(color: AppColors.textGray),
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: AppColors.primaryBlue, child: Text('I', style: TextStyle(color: Colors.white))),
                      title: const Text('Iván Jiménez', style: TextStyle(color: AppColors.textLight)),
                      subtitle: Text('${provider._allLeads.where((l) => l.assignedTo == 'Iván Jiménez').length} leads asignados', style: const TextStyle(color: AppColors.textGray)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Text('Activo', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
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
}

class _AdminKPICard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _AdminKPICard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textLight)),
              ],
            ),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textGray)),
          ],
        ),
      ),
    );
  }
}
