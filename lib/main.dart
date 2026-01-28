import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:aetheria_crm/models.dart';
import 'package:aetheria_crm/provider.dart';
import 'package:aetheria_crm/screens/vendedor/calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
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
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor complete todos los campos');
      return;
    }

    final provider = context.read<CRMProvider>();
    
    // Intentar login como admin
    if (provider.authenticateAdmin(email, password)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
      return;
    }
    
    // Intentar login como vendedor
    if (provider.authenticateVendedor(email, password)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VendedorDashboard()),
      );
      return;
    }
    
    // Login fallido
    setState(() => _errorMessage = 'Email o contraseña incorrectos');
  }

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
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                                onSubmitted: (_) => _handleLogin(),
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                              const SizedBox(height: 32),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Credenciales de prueba:',
                                style: TextStyle(fontSize: 12, color: AppColors.textGray),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Admin: admin@aetheria.com / admin123',
                                style: TextStyle(fontSize: 11, color: AppColors.textGray),
                              ),
                              const Text(
                                'David: david@aetheriaagency.es / david123',
                                style: TextStyle(fontSize: 11, color: AppColors.textGray),
                              ),
                              const Text(
                                'Iván: ivan@aetheriaagency.es / ivan123',
                                style: TextStyle(fontSize: 11, color: AppColors.textGray),
                              ),
                            ],
                          ),
                        ),
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
class VendedorDashboard extends StatefulWidget {
  const VendedorDashboard({Key? key}) : super(key: key);

  @override
  State<VendedorDashboard> createState() => _VendedorDashboardState();
}

class _VendedorDashboardState extends State<VendedorDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final salespersonName = provider.currentSalespersonName ?? 'Vendedor';
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${salespersonName.split(' ')[0]}'),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendario'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Facturación'),
          ],
          indicatorColor: AppColors.primaryPurple,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(provider, context),
          const CalendarScreen(),
          _buildBillingTab(provider, context),
        ],
      ),
    );
  }

  Widget _buildBillingTab(CRMProvider provider, BuildContext context) {
    final salespersonName = provider.currentSalespersonName ?? '';
    final isAdmin = provider.currentRole == 'admin';
    
    // Calcular facturación del mes actual
    final currentMonth = DateTime.now();
    final billing = provider.calculateSalespersonBilling(salespersonName, month: currentMonth);
    
    // Obtener facturas del agente
    final invoices = provider.getInvoicesBySalesperson(salespersonName);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs de Facturación
          const Text('Facturación del Mes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 8),
          Text(
            _getMonthName(currentMonth.month) + ' ${currentMonth.year}',
            style: const TextStyle(fontSize: 16, color: AppColors.textGray),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _KPICard('Total Facturado', '€${billing['totalAmount'].toStringAsFixed(2)}', Icons.euro)),
              const SizedBox(width: 16),
              Expanded(child: _KPICard('Ventas Cerradas', billing['closedLeadsCount'].toString(), Icons.check_circle)),
              const SizedBox(width: 16),
              Expanded(child: _KPICard('Facturas Subidas', invoices.where((i) => i.status == 'Subida' || i.status == 'Pagada').length.toString(), Icons.upload_file)),
            ],
          ),
          
          // Lista de Leads Cerrados
          const SizedBox(height: 32),
          const Text('Leads Cerrados Este Mes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 16),
          if ((billing['closedLeads'] as List).isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No hay leads cerrados este mes', style: TextStyle(color: AppColors.textGray)),
                ),
              ),
            )
          else
            ...(billing['closedLeads'] as List).map((lead) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text(lead.company, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                subtitle: Text('${lead.contact} • ${lead.sector}', style: const TextStyle(color: AppColors.textGray)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '€${lead.amount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
          
          // Subir Factura
          const SizedBox(height: 32),
          const Text('Mis Facturas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 16),
          
          // Botón para subir factura
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.upload_file, color: Colors.white),
              ),
              title: const Text('Subir Factura del Mes', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
              subtitle: Text('Total a facturar: €${billing['totalAmount'].toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textGray)),
              trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textGray, size: 16),
              onTap: () => _showUploadInvoiceDialog(provider, billing),
            ),
          ),
          
          // Lista de Facturas Subidas
          const SizedBox(height: 16),
          if (invoices.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No has subido facturas aún', style: TextStyle(color: AppColors.textGray)),
                ),
              ),
            )
          else
            ...invoices.reversed.map((invoice) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(invoice.status).withValues(alpha: 0.2),
                  child: Icon(_getStatusIcon(invoice.status), color: _getStatusColor(invoice.status)),
                ),
                title: Text('Factura ${invoice.month}', style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('€${invoice.totalAmount.toStringAsFixed(2)} • ${invoice.closedLeadsCount} leads', style: const TextStyle(color: AppColors.textGray)),
                    if (invoice.pdfFileName != null)
                      Text('📄 ${invoice.pdfFileName}', style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(invoice.status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    invoice.status,
                    style: TextStyle(color: _getStatusColor(invoice.status), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                onTap: isAdmin ? () => _showInvoiceDetailsDialog(context, provider, invoice) : null,
              ),
            )),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pagada': return Colors.green;
      case 'Subida': return Colors.blue;
      case 'Pendiente': return Colors.orange;
      default: return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pagada': return Icons.check_circle;
      case 'Subida': return Icons.upload_file;
      case 'Pendiente': return Icons.pending;
      default: return Icons.info;
    }
  }
  
  String _getMonthName(int month) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return months[month - 1];
  }
  
  void _showUploadInvoiceDialog(CRMProvider provider, Map<String, dynamic> billing) {
    final fileNameController = TextEditingController();
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subir Factura'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mes: ${_getMonthName((billing['month'] as DateTime).month)} ${(billing['month'] as DateTime).year}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: €${billing['totalAmount'].toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: AppColors.textGray),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Archivo PDF',
                  border: OutlineInputBorder(),
                  hintText: 'factura_enero_2026.pdf',
                  prefixIcon: Icon(Icons.insert_drive_file),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Comentarios adicionales',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'En una versión real, aquí podrías seleccionar y subir tu archivo PDF.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
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
              if (fileNameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor ingresa el nombre del archivo'), backgroundColor: Colors.red),
                );
                return;
              }
              
              final invoice = Invoice(
                id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
                salespersonName: provider.currentSalespersonName!,
                salespersonEmail: provider.currentSalesperson!,
                month: '${_getMonthName((billing['month'] as DateTime).month)} ${(billing['month'] as DateTime).year}',
                totalAmount: billing['totalAmount'],
                closedLeadsCount: billing['closedLeadsCount'],
                pdfFileName: fileNameController.text.trim(),
                pdfUrl: 'simulado://facturas/${fileNameController.text.trim()}',
                status: 'Subida',
                notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
              );
              
              provider.addInvoice(invoice);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Factura subida correctamente'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
            child: const Text('Subir Factura'),
          ),
        ],
      ),
    );
  }
  
  void _showInvoiceDetailsDialog(BuildContext context, CRMProvider provider, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Factura ${invoice.month}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow('Agente:', invoice.salespersonName),
              _DetailRow('Email:', invoice.salespersonEmail),
              _DetailRow('Total:', '€${invoice.totalAmount.toStringAsFixed(2)}'),
              _DetailRow('Leads Cerrados:', invoice.closedLeadsCount.toString()),
              _DetailRow('Archivo:', invoice.pdfFileName ?? 'No subido'),
              _DetailRow('Estado:', invoice.status),
              if (invoice.notes != null) _DetailRow('Notas:', invoice.notes!),
              const SizedBox(height: 16),
              if (provider.currentRole == 'admin')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          provider.updateInvoice(invoice.id, status: 'Pagada');
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Factura marcada como pagada'), backgroundColor: Colors.green),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Marcar Pagada'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          if (provider.currentRole == 'admin')
            TextButton(
              onPressed: () {
                provider.deleteInvoice(invoice.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Factura eliminada'), backgroundColor: Colors.orange),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab(CRMProvider provider, BuildContext context) {
    return SingleChildScrollView(
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
                _StageColumn('Contactado', provider, context),
                _StageColumn('Reunión Agendada', provider, context),
                _StageColumn('Seguimiento', provider, context),
                _StageColumn('Presupuestado', provider, context),
                _StageColumn('Cerrado', provider, context),
                _StageColumn('Onboarding', provider, context),
                _StageColumn('Lost', provider, context),
                _StageColumn('Ghosting', provider, context),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tareas de Hoy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
              ElevatedButton.icon(
                onPressed: () => _showCreateTaskDialog(provider),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva Tarea'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tareas pendientes
          if (provider.tasks.where((t) => !t.isCompleted).isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Pendientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textGray)),
            ),
            ...provider.tasks.where((t) => !t.isCompleted).map((task) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) {
                    provider.toggleTaskComplete(task.id);
                  },
                  activeColor: AppColors.primaryPurple,
                ),
                title: Text(
                  task.title, 
                  style: const TextStyle(color: AppColors.textLight),
                ),
                subtitle: task.isFollowUp ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryPurple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Seguimiento 24-48h', style: TextStyle(fontSize: 11, color: AppColors.primaryPurple)),
                ) : null,
                trailing: Text(
                  '${task.dueDate.day}/${task.dueDate.month}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                ),
              ),
            )),
          ],
          // Tareas completadas
          if (provider.tasks.where((t) => t.isCompleted).isNotEmpty) ...[
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Completadas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green)),
            ),
            ...provider.tasks.where((t) => t.isCompleted).map((task) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: AppColors.cardDark.withValues(alpha: 0.5),
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
                    color: AppColors.textGray,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.textGray,
                  ),
                ),
                subtitle: task.isFollowUp ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Seguimiento 24-48h', style: TextStyle(fontSize: 11, color: Colors.green)),
                ) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${task.dueDate.day}/${task.dueDate.month}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            )),
          ],
          if (provider.tasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No hay tareas para hoy',
                    style: TextStyle(color: AppColors.textGray),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Crear nueva tarea desde el dashboard
  void _showCreateTaskDialog(CRMProvider provider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedLeadId;
    bool isFollowUp = false;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Crear Nueva Tarea'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la Tarea *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Lead Relacionado (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedLeadId,
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
                  ListTile(
                    title: const Text('Fecha de Vencimiento'),
                    subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Seguimiento 24-48h'),
                    subtitle: const Text('Marca como seguimiento urgente'),
                    value: isFollowUp,
                    onChanged: (value) {
                      setState(() => isFollowUp = value ?? false);
                    },
                    activeColor: AppColors.primaryPurple,
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

                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  leadId: selectedLeadId ?? '',
                  isCompleted: false,
                  isFollowUp: isFollowUp,
                  assignedTo: provider.currentSalespersonName ?? '',
                  dueDate: selectedDate,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                );

                provider.addTask(task);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tarea "${titleController.text}" creada'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              child: const Text('Crear Tarea'),
            ),
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
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendario'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Facturación'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text('Equipos y Vendedores'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageTeamsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Modo Espejo'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: _getSelectedScreen(provider),
    );
  }

  Widget _getSelectedScreen(CRMProvider provider) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(provider);
      case 1:
        return const CalendarScreen();
      case 2:
        return _buildAdminBillingTab(provider);
      case 4:
        return _buildEspejoMode(provider);
      default:
        return _buildDashboard(provider);
    }
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
                  }),
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
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBillingTab(CRMProvider provider) {
    // Calcular facturación total de todos los agentes
    final currentMonth = DateTime.now();
    final allBilling = provider.calculateAllSalespersonsBilling(month: currentMonth);
    
    // Calcular totales
    final totalAmount = allBilling.fold<double>(0, (sum, billing) => sum + billing['totalAmount']);
    final totalClosedLeads = allBilling.fold<int>(0, (sum, billing) => sum + (billing['closedLeadsCount'] as int));
    final allInvoices = provider.allInvoices;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs Globales
          const Text('Facturación Global', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 8),
          Text(
            _getMonthName(currentMonth.month) + ' ${currentMonth.year}',
            style: const TextStyle(fontSize: 16, color: AppColors.textGray),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _KPICard('Total Facturado', '€${totalAmount.toStringAsFixed(2)}', Icons.euro)),
              const SizedBox(width: 16),
              Expanded(child: _KPICard('Ventas Cerradas', totalClosedLeads.toString(), Icons.check_circle)),
              const SizedBox(width: 16),
              Expanded(child: _KPICard('Facturas Totales', allInvoices.length.toString(), Icons.receipt)),
            ],
          ),
          
          // Facturación por Agente
          const SizedBox(height: 32),
          const Text('Facturación por Agente', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 16),
          ...allBilling.map((billing) {
            final invoices = provider.getInvoicesBySalesperson(billing['salespersonName']);
            final hasInvoice = invoices.isNotEmpty;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                  child: Text(
                    (billing['salespersonName'] as String).substring(0, 1),
                    style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  billing['salespersonName'],
                  style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      '€${billing['totalAmount'].toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${billing['closedLeadsCount']} leads',
                      style: const TextStyle(color: AppColors.textGray),
                    ),
                  ],
                ),
                trailing: hasInvoice
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Facturada',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Pendiente',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Leads Cerrados:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight)),
                        const SizedBox(height: 8),
                        if ((billing['closedLeads'] as List).isEmpty)
                          const Text('No hay leads cerrados este mes', style: TextStyle(color: AppColors.textGray))
                        else
                          ...(billing['closedLeads'] as List).map((lead) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${lead.company} - €${lead.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(color: AppColors.textLight),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        const SizedBox(height: 16),
                        const Text('Facturas:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textLight)),
                        const SizedBox(height: 8),
                        if (invoices.isEmpty)
                          const Text('No ha subido facturas', style: TextStyle(color: AppColors.textGray))
                        else
                          ...invoices.map((invoice) => ListTile(
                            dense: true,
                            leading: Icon(
                              _getStatusIcon(invoice.status),
                              color: _getStatusColor(invoice.status),
                              size: 20,
                            ),
                            title: Text(
                              invoice.pdfFileName ?? 'Sin archivo',
                              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(invoice.status).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                invoice.status,
                                style: TextStyle(
                                  color: _getStatusColor(invoice.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            onTap: () => _showInvoiceDetailsDialog(context, provider, invoice),
                          )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Métodos helper para la gestión de facturación
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pagada': return Colors.green;
      case 'Subida': return Colors.blue;
      case 'Pendiente': return Colors.orange;
      default: return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pagada': return Icons.check_circle;
      case 'Subida': return Icons.upload_file;
      case 'Pendiente': return Icons.pending;
      default: return Icons.info;
    }
  }
  
  String _getMonthName(int month) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return months[month - 1];
  }
  
  void _showInvoiceDetailsDialog(BuildContext context, CRMProvider provider, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Factura ${invoice.month}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow('Vendedor', invoice.salespersonName),
              const SizedBox(height: 8),
              _InfoRow('Mes', invoice.month),
              const SizedBox(height: 8),
              _InfoRow('Total Facturado', '€${invoice.totalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _InfoRow('Leads Cerrados', '${invoice.closedLeadsCount}'),
              const SizedBox(height: 8),
              _InfoRow('Estado', invoice.status),
              const SizedBox(height: 8),
              _InfoRow('Fecha Subida', '${invoice.uploadedAt.day}/${invoice.uploadedAt.month}/${invoice.uploadedAt.year}'),
              const SizedBox(height: 8),
              _InfoRow('Archivo', invoice.pdfFileName ?? 'Sin archivo'),
              if (invoice.notes?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                const Text('Notas:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(invoice.notes ?? '', style: const TextStyle(color: AppColors.textGray)),
              ],
            ],
          ),
        ),
        actions: [
          if (invoice.status != 'Pagada')
            TextButton(
              onPressed: () {
                provider.updateInvoiceStatus(invoice.id, 'Pagada');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Factura marcada como pagada'), backgroundColor: Colors.green),
                );
              },
              child: const Text('Marcar como Pagada', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                provider.deleteInvoice(invoice.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Factura eliminada'), backgroundColor: Colors.orange),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
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

    return SingleChildScrollView(
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
                      _StageColumn('Contactado', provider, context),
                      _StageColumn('Reunión Agendada', provider, context),
                      _StageColumn('Seguimiento', provider, context),
                      _StageColumn('Presupuestado', provider, context),
                      _StageColumn('Cerrado', provider, context),
                      _StageColumn('Onboarding', provider, context),
                      _StageColumn('Lost', provider, context),
                      _StageColumn('Ghosting', provider, context),
                    ],
                  ),
                ),
              ],
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

// Create Lead Screen
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
  String? _selectedSalesperson;

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
    final provider = context.read<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Información de la Empresa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la Empresa *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(
                          labelText: 'Persona de Contacto *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || v.isEmpty || !v.contains('@') ? 'Email válido requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _sectorController,
                              decoration: const InputDecoration(
                                labelText: 'Sector',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _teamSizeController,
                              decoration: const InputDecoration(
                                labelText: 'Tamaño del Equipo',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
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
                      const Text('Detalles del Lead', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedStage,
                        decoration: const InputDecoration(
                          labelText: 'Etapa Inicial',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Contactado', child: Text('Contactado')),
                          DropdownMenuItem(value: 'Reunión Agendada', child: Text('Reunión Agendada')),
                          DropdownMenuItem(value: 'Seguimiento', child: Text('Seguimiento')),
                          DropdownMenuItem(value: 'Presupuestado', child: Text('Presupuestado')),
                          DropdownMenuItem(value: 'Cerrado', child: Text('Cerrado')),
                          DropdownMenuItem(value: 'Onboarding', child: Text('Onboarding')),
                          DropdownMenuItem(value: 'Lost', child: Text('Lost')),
                          DropdownMenuItem(value: 'Ghosting', child: Text('Ghosting')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedStage = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Monto Estimado (€)',
                          border: OutlineInputBorder(),
                          prefixText: '€ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          if (double.tryParse(v) == null) return 'Ingresa un número válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSalesperson,
                        decoration: const InputDecoration(
                          labelText: 'Asignar a Vendedor',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Auto-asignar')),
                          ...provider.allSalespersons.where((s) => s.isActive).map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedSalesperson = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newLead = Lead(
                            id: 'lead_${DateTime.now().millisecondsSinceEpoch}',
                            company: _companyController.text,
                            contact: _contactController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            sector: _sectorController.text,
                            teamSize: _teamSizeController.text,
                            stage: _selectedStage,
                            amount: double.parse(_amountController.text),
                            assignedTo: _selectedSalesperson ?? provider.currentSalesperson ?? 'David Jiménez',
                            createdAt: DateTime.now(),
                            notes: [],
                            activities: [],
                          );
                          
                          provider.addLead(newLead);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lead "${newLead.company}" creado exitosamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Crear Lead'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Lead Detail Screen
class LeadDetailScreen extends StatefulWidget {
  final String leadId;
  
  const LeadDetailScreen({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final _noteController = TextEditingController();
  
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    final lead = provider.allLeads.firstWhere((l) => l.id == widget.leadId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(lead.company),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reassign') {
                _showReassignDialog(context, provider, lead);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reassign', child: Text('Reasignar Vendedor')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              const Text('Empresa', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                              const SizedBox(height: 4),
                              Text(lead.company, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primaryPurple, AppColors.primaryBlue]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('€${lead.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _InfoRow('Contacto', lead.contact),
                    _InfoRow('Email', lead.email),
                    _InfoRow('Teléfono', lead.phone),
                    _InfoRow('Sector', lead.sector),
                    _InfoRow('Tamaño Equipo', lead.teamSize),
                    _InfoRow('Asignado a', lead.assignedTo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Etapa Actual', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<String>(
                  value: lead.stage,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Contactado', child: Text('Contactado')),
                    DropdownMenuItem(value: 'Reunión Agendada', child: Text('Reunión Agendada')),
                    DropdownMenuItem(value: 'Seguimiento', child: Text('Seguimiento')),
                    DropdownMenuItem(value: 'Presupuestado', child: Text('Presupuestado')),
                    DropdownMenuItem(value: 'Cerrado', child: Text('Cerrado')),
                    DropdownMenuItem(value: 'Onboarding', child: Text('Onboarding')),
                    DropdownMenuItem(value: 'Lost', child: Text('Lost')),
                    DropdownMenuItem(value: 'Ghosting', child: Text('Ghosting')),
                  ],
                  onChanged: (newStage) {
                    if (newStage != null) {
                      provider.updateLeadStage(lead.id, newStage);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Etapa actualizada a $newStage'), backgroundColor: Colors.green),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Añadir Nota', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Escribe una nota...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_noteController.text.isNotEmpty) {
                            provider.addNote(lead.id, _noteController.text);
                            _noteController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nota añadida'), backgroundColor: Colors.green),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Añadir Nota'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Registrar Actividad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActivityButton('Llamada', Icons.phone, () => _addActivity(provider, lead.id, 'Llamada')),
                _ActivityButton('WhatsApp', Icons.chat, () => _addActivity(provider, lead.id, 'WhatsApp')),
                _ActivityButton('Email', Icons.email, () => _addActivity(provider, lead.id, 'Email')),
                _ActivityButton('Reunión', Icons.event, () => _addActivity(provider, lead.id, 'Reunión')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Historial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
            const SizedBox(height: 12),
            // Actividades
            ...lead.activities.map((activity) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                  child: Icon(_getActivityIcon(activity.type), color: AppColors.primaryPurple, size: 20),
                ),
                title: Text(activity.type, style: const TextStyle(color: AppColors.textLight)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.description, style: const TextStyle(color: AppColors.textGray)),
                    const SizedBox(height: 4),
                    Text(
                      'Por: ${activity.createdBy}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textGray, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatDate(activity.date), style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    // Solo admin puede editar/eliminar
                    if (provider.currentRole == 'admin') ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: AppColors.textGray, size: 20),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditActivityDialog(provider, lead.id, activity);
                          } else if (value == 'delete') {
                            _showDeleteActivityDialog(provider, lead.id, activity);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18, color: AppColors.primaryBlue),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )),
            // Notas
            ...lead.notes.map((note) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.cardDark,
                  child: Icon(Icons.note, color: AppColors.primaryBlue, size: 20),
                ),
                title: Text(note.text, style: const TextStyle(color: AppColors.textLight)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatDate(note.date), style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    // Solo admin puede editar/eliminar
                    if (provider.currentRole == 'admin') ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: AppColors.textGray, size: 20),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditNoteDialog(provider, lead.id, note);
                          } else if (value == 'delete') {
                            _showDeleteNoteDialog(provider, lead.id, note);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18, color: AppColors.primaryBlue),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _addActivity(CRMProvider provider, String leadId, String type) {
    provider.addActivity(leadId, type, 'Actividad de $type registrada');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type registrado'), backgroundColor: Colors.green),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'Llamada': return Icons.phone;
      case 'WhatsApp': return Icons.chat;
      case 'Email': return Icons.email;
      case 'Reunión': return Icons.event;
      default: return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Editar actividad
  void _showEditActivityDialog(CRMProvider provider, String leadId, Activity activity) {
    final typeController = TextEditingController(text: activity.type);
    final descController = TextEditingController(text: activity.description);
    String selectedType = activity.type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Actividad'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Actividad',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Llamada', child: Text('Llamada')),
                    DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp')),
                    DropdownMenuItem(value: 'Email', child: Text('Email')),
                    DropdownMenuItem(value: 'Reunión', child: Text('Reunión')),
                    DropdownMenuItem(value: 'Nota', child: Text('Nota')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                provider.updateActivity(leadId, activity.id, selectedType, descController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Actividad actualizada'), backgroundColor: Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  // Eliminar actividad
  void _showDeleteActivityDialog(CRMProvider provider, String leadId, Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Actividad'),
        content: Text('¿Estás seguro de eliminar la actividad "${activity.type}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteActivity(leadId, activity.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Actividad eliminada'), backgroundColor: Colors.orange),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Editar nota
  void _showEditNoteDialog(CRMProvider provider, String leadId, Note note) {
    final textController = TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nota'),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Nota',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateNote(leadId, note.id, textController.text);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nota actualizada'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Eliminar nota
  void _showDeleteNoteDialog(CRMProvider provider, String leadId, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Nota'),
        content: const Text('¿Estás seguro de eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteNote(leadId, note.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nota eliminada'), backgroundColor: Colors.orange),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showReassignDialog(BuildContext context, CRMProvider provider, Lead lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reasignar Vendedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: provider.allSalespersons.where((s) => s.isActive).map((salesperson) {
            return ListTile(
              title: Text(salesperson.name),
              onTap: () {
                provider.reassignLead(lead.id, salesperson.name);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lead reasignado a ${salesperson.name}'), backgroundColor: Colors.green),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // Métodos helper para AdminDashboard
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pagada': return Colors.green;
      case 'Subida': return Colors.blue;
      case 'Pendiente': return Colors.orange;
      default: return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pagada': return Icons.check_circle;
      case 'Subida': return Icons.upload_file;
      case 'Pendiente': return Icons.pending;
      default: return Icons.info;
    }
  }
  
  String _getMonthName(int month) {
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return months[month - 1];
  }
  
  void _showInvoiceDetailsDialog(BuildContext context, CRMProvider provider, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Factura ${invoice.month}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow('Agente:', invoice.salespersonName),
              _DetailRow('Email:', invoice.salespersonEmail),
              _DetailRow('Total:', '€${invoice.totalAmount.toStringAsFixed(2)}'),
              _DetailRow('Leads Cerrados:', invoice.closedLeadsCount.toString()),
              _DetailRow('Archivo:', invoice.pdfFileName ?? 'No subido'),
              _DetailRow('Estado:', invoice.status),
              if (invoice.notes != null) _DetailRow('Notas:', invoice.notes!),
              const SizedBox(height: 16),
              if (provider.currentRole == 'admin')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          provider.updateInvoice(invoice.id, status: 'Pagada');
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Factura marcada como pagada'), backgroundColor: Colors.green),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Marcar Pagada'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          if (provider.currentRole == 'admin')
            TextButton(
              onPressed: () {
                provider.deleteInvoice(invoice.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Factura eliminada'), backgroundColor: Colors.orange),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: AppColors.textGray)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textGray)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textLight)),
          ),
        ],
      ),
    );
  }
}

class _ActivityButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActivityButton(this.label, this.icon, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardDark,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

// Manage Teams Screen
class ManageTeamsScreen extends StatelessWidget {
  const ManageTeamsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CRMProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos y Vendedores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSalespersonDialog(context, provider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Equipo Principal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    const Text('AetherIA Agency', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TeamStat('Vendedores Activos', provider.allSalespersons.where((s) => s.isActive).length.toString()),
                          ),
                          Container(width: 1, height: 40, color: AppColors.textGray),
                          Expanded(
                            child: _TeamStat('Leads Totales', provider.allLeads.length.toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Vendedores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textLight)),
            const SizedBox(height: 12),
            ...provider.allSalespersons.map((salesperson) {
              final leadsCount = provider.allLeads.where((l) => l.assignedTo == salesperson.name).length;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: salesperson.isActive ? AppColors.primaryPurple.withValues(alpha: 0.2) : AppColors.textGray.withValues(alpha: 0.2),
                    child: Text(salesperson.name[0], style: TextStyle(color: salesperson.isActive ? AppColors.primaryPurple : AppColors.textGray, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(salesperson.name, style: TextStyle(color: salesperson.isActive ? AppColors.textLight : AppColors.textGray)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(salesperson.email, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                      const SizedBox(height: 4),
                      Text('$leadsCount leads asignados', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
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
                          style: TextStyle(fontSize: 12, color: salesperson.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditSalespersonDialog(context, provider, salesperson),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddSalespersonDialog(BuildContext context, CRMProvider provider) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Vendedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                provider.addSalesperson(Salesperson(
                  id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  team: 'AetherIA Agency',
                  isActive: true,
                ));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vendedor añadido exitosamente'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }

  void _showEditSalespersonDialog(BuildContext context, CRMProvider provider, Salesperson salesperson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar: ${salesperson.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Activar/Desactivar'),
              trailing: Switch(
                value: salesperson.isActive,
                onChanged: (value) {
                  provider.toggleSalespersonStatus(salesperson.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${salesperson.name} ${value ? 'activado' : 'desactivado'}'), backgroundColor: Colors.green),
                  );
                },
                activeColor: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}

class _TeamStat extends StatelessWidget {
  final String label;
  final String value;

  const _TeamStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray), textAlign: TextAlign.center),
      ],
    );
  }
}
