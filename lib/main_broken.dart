import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'provider.dart';

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
        boxShadow: [BoxShadow(color: AppColors.primaryPurple.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
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
    final provider = context.watch<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Vendedor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            provider.logout();
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
            children: provider.allSalespersons.where((s) => s.isActive).map((salesperson) {
              return _SalespersonCard(
                name: salesperson.name,
                email: salesperson.email,
                onTap: () {
                  provider.selectSalesperson(salesperson.name);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const VendedorDashboard()));
                },
              );
            }).toList(),
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
                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
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
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Crear Lead',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateLeadScreen()));
            },
          ),
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
                  _StageColumn('Prospección', provider, context),
                  _StageColumn('Contacto/Agendado', provider, context),
                  _StageColumn('Diagnóstico', provider, context),
                  _StageColumn('Propuesta', provider, context),
                  _StageColumn('Cierre', provider, context),
                  _StageColumn('Onboarding', provider, context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tareas de Hoy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
            const SizedBox(height: 16),
            ...provider.tasks.map((task) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) {
                    provider.toggleTaskComplete(task.id);
                  },
                  activeColor: AppColors.primaryPurple,
                ),
                title: Text(task.title, style: const TextStyle(color: AppColors.textLight)),
                subtitle: task.isFollowUp ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryPurple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
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
  final BuildContext parentContext;

  const _StageColumn(this.stage, this.provider, this.parentContext);

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
                  child: InkWell(
                    onTap: () {
                      Navigator.of(parentContext).push(
                        MaterialPageRoute(builder: (_) => LeadDetailScreen(leadId: lead.id)),
                      );
                    },
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
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Crear Lead',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateLeadScreen()));
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.cardDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text('Administrador', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('Equipos y Vendedores'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageTeamsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Modo Espejo'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? _buildDashboard(provider) : _buildEspejoMode(provider),
    );
  }

  Widget _buildDashboard(CRMProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Insights del Negocio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _AdminKPICard('Total Leads', provider.allLeads.length.toString(), Icons.business)),
              const SizedBox(width: 16),
              Expanded(child: _AdminKPICard('Conversión Global', '${((provider.allLeads.where((l) => l.stage == 'Onboarding').length / provider.allLeads.length) * 100).toStringAsFixed(1)}%', Icons.trending_up)),
              const SizedBox(width: 16),
              Expanded(child: _AdminKPICard('Pipeline Total', '€${provider.allLeads.fold(0.0, (sum, l) => sum + l.amount).toStringAsFixed(0)}', Icons.euro)),
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
                  const Text('Vendedores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                  const SizedBox(height: 16),
                  ...provider.allSalespersons.where((s) => s.isActive).map((salesperson) {
                    final leadsCount = provider.allLeads.where((l) => l.assignedTo == salesperson.name).length;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                        child: Text(salesperson.name[0], style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(salesperson.name, style: const TextStyle(color: AppColors.textLight)),
                      subtitle: Text('$leadsCount leads asignados', style: const TextStyle(color: AppColors.textGray)),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          provider.enterEspejoMode(salesperson.name);
                          setState(() => _selectedIndex = 2);
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Ver como', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEspejoMode(CRMProvider provider) {
    if (provider.espejoSalesperson == null) {
      return const Center(
        child: Text('Selecciona un vendedor en el dashboard', style: TextStyle(color: AppColors.textGray)),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
          ),
          child: Row(
            children: [
              const Icon(Icons.visibility, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Modo Espejo: viendo como ${provider.espejoSalesperson}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  provider.exitEspejoMode();
                  setState(() => _selectedIndex = 0);
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Salir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
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
                      _StageColumn('Prospección', provider, context),
                      _StageColumn('Contacto/Agendado', provider, context),
                      _StageColumn('Diagnóstico', provider, context),
                      _StageColumn('Propuesta', provider, context),
                      _StageColumn('Cierre', provider, context),
                      _StageColumn('Onboarding', provider, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
