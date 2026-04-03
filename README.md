# Proyecto: Inventra — Sistema de Gestión y Control de Inventarios

Inventra es una solución administrativa multiplataforma de alto rendimiento, orientada a la gestión precisa de activos, stock y flujos operativos en almacenes y negocios de escala media. Diseñada bajo una arquitectura robusta de capas, garantiza integridad de datos, escalabilidad y una experiencia de usuario optimizada para la productividad.

## Características Principales

### Gestión de Catálogo y Activos
- **Estructura de Categorías**: Organización jerárquica con control de estados lógicos para el filtrado eficiente de catálogos.
- **Fichas de Producto**: Registro detallado de especificaciones técnicas, control de stock mínimo y trazabilidad de precios.

### Control Operativo de Inventario
- **Movimientos de Stock**: Registro de entradas y salidas con validación atómica para prevenir inconsistencias o stocks negativos.
- **Auditoría y Trazabilidad**: Historial cronológico completo de cada alteración en los niveles de existencias por producto.

### Administración de Personal y Seguridad
- **Control de Acceso (RBAC)**: Roles definidos de Administrador, Supervisor y Operador con permisos granulares.
- **Integridad de Datos (RLS)**: Implementación de Row Level Security (RLS) a nivel de base de datos para el aislamiento seguro de la información.

### Ecosistema Multiplataforma
- **Consola de Administración**: Dashboard en tiempo real con KPIs operativos y monitoreo de actividad reciente.
- **Acceso Multidispositivo**: Soporte nativo para plataformas Web, Windows y Android.

## Arquitectura del Software

El proyecto implementa una arquitectura "Feature-First", segregando la lógica de negocio, los datos y la presentación en módulos independientes:

- **Presentation Layer**: Lógica de interfaz de usuario y manejo de estados visuales.
- **Application Layer**: Orquestación de casos de uso y providers de estado reactivo.
- **Domain Layer**: Definición de entidades puras, contratos y reglas de negocio.
- **Data Layer**: Repositorios concretos e integración con el SDK de Supabase (PostgreSQL, Auth, Storage).

## Especificaciones del Stack Tecnológico

- **Framework**: Flutter & Dart (v3.29.0+)
- **Gestión de Estado**: Riverpod 2.x (AsyncNotifiers, StateProviders)
- **Ruteo y Navegación**: go_router para gestión declarativa de rutas y Guards.
- **Infraestructura**: Supabase (Autenticación, Almacenamiento, Tiempo Real, Base de datos Relacional).

## Guía de Instalación y Despliegue

1. **Prerrequisitos**: Poseer el SDK de Flutter instalado y configurado.
2. **Obtención del Código**:
   ```bash
   git clone https://github.com/Sakurayo-Crispita/inventra.git
   cd inventra
   ```
3. **Instalación de Dependencias**:
   ```bash
   flutter pub get
   ```
4. **Ejecución del Entorno de Desarrollo**:
   ```bash
   flutter run -d [id-del-dispositivo]
   ```

---
© 2026 Inventra Software Group. Todos los derechos reservados.
