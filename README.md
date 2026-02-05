# AetherIA CRM

Sistema de gestión de relaciones con clientes (CRM) desarrollado en Flutter.

## 🚀 Características

- ✅ Dashboard con vista Kanban de leads (4x2 grid)
- ✅ Gestión de leads con edición completa
- ✅ Calendario de reuniones con estados (Completada/Perdida/Pendiente)
- ✅ Sistema de tareas y seguimientos
- ✅ Facturación y reportes
- ✅ Integración con Firebase
- ✅ Roles de usuario (Admin/Vendedor)

## 🛠️ Tecnologías

- **Flutter 3.35.4**
- **Dart 3.9.2**
- **Firebase** (Firestore, Auth)
- **Provider** para state management
- **Material Design 3**

## 📦 Despliegue Web

### Build Web
```bash
flutter build web --release
```

### Servir localmente
```bash
cd build/web
python3 -m http.server 8000
```

## 🔧 Configuración

1. Clona el repositorio
2. Instala dependencias: `flutter pub get`
3. Configura Firebase (google-services.json)
4. Ejecuta: `flutter run -d chrome`

## 📱 Credenciales de Prueba

**Administrador:**
- Email: admin@aetheriaagency.es
- Password: admin123

**Vendedor:**
- Email: ivan@aetheriaagency.es
- Password: password123

## 🌐 Desplegar en Cloudflare Pages

1. Conecta este repositorio en Cloudflare Pages
2. Build command: `flutter build web --release`
3. Build output: `build/web`
4. Deploy automáticamente en cada push

---

Desarrollado por AetherIA Agency
