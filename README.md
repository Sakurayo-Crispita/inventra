# Inventra — Panel Administrativo & Gestión de Inventario

![Inventra Banner](https://images.unsplash.com/photo-1553413077-190dd305871c?auto=format&fit=crop&q=80&w=1200)

**Inventra** es una solución multiplataforma moderna diseñada para el control quirúrgico de inventarios, productos y movimientos operativos. Construida con un enfoque en la escalabilidad, la velocidad y la experiencia de usuario premium.

---

## 🚀 Características del MVP

### 📋 Gestión de Catálogo
- **Categorías**: Organización jerárquica y estados activos/inactivos.
- **Productos**: Fichas técnicas con stock mínimo, precios y asociación categorizada.

### 📦 Control de Inventario
- **Movimientos Atómicos**: Registro riguroso de entradas y salidas.
- **Validación de Stock**: Protección a nivel de base de datos para evitar stocks negativos.
- **Historial Completo**: Trazabilidad de cada cambio en el almacén.

### 👥 Administración de Usuarios
- **Roles Base**: Administrador, Supervisor y Operador.
- **Seguridad RLS**: Políticas de seguridad de nivel de fila (Row Level Security) en Supabase.
- **Perfiles**: Saludos personalizados y gestión de estados de cuenta.

### 🌐 Landing Web & Dashboard
- **Landing Pública**: Presentación comercial responsive con acceso inteligente al panel.
- **Dashboard en Tiempo Real**: KPIs críticos y actividad reciente al instante.

---

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter & Dart (v3.x)
- **Estado**: Riverpod (AsyncNotifier, StateProvider)
- **Navegación**: go_router
- **Backend & DB**: Supabase (Auth, Storage, Realtime, Postgres)
- **Arquitectura**: Feature-first (Domain, Data, Application, Presentation)

---

## 🏗️ Arquitectura: Feature-First

El proyecto sigue una estructura modular orientada a funcionalidades:

```text
lib/
  core/           # Temas, Routing, Widgets globales y utilidades
  features/       # Módulos independientes
    auth/         # Login, registro y guardianes
    inventory/    # Movimientos y stock
    products/     # Catálogo de productos
    users/        # Gestión de perfiles y roles
    settings/     # Configuración del negocio
    landing/      # Web pública de marketing
```

Cada *feature* se divide en capas:
- **Presentation**: UI, widgets y estados visuales.
- **Application**: Providers y lógica de casos de uso.
- **Domain**: Entidades y reglas de negocio.
- **Data**: Repositorios y fuentes de datos (Supabase).

---

## 🏁 Instalación y Ejecución

1. **Clonar repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/inventra.git
   ```
2. **Configurar Supabase**:
   Asegúrate de tener las tablas de `profiles`, `categories`, `products`, `inventory_movements` y `settings` configuradas.
3. **Ejecutar**:
   ```bash
   flutter pub get
   flutter run
   ```

---

## 📸 Screenshots (MVP)

> [Secciones reservadas para capturas de Dashboard, Inventario y Landing]

---

## 📄 Licencia
Este proyecto es un MVP desarrollado profesionalmente para fines operativos y de portafolio.
© 2026 Inventra Team.
