# Inventra — Documento Maestro de Producto + SRS Comercial
**Versión:** 1.0  
**Fecha:** Abril 2026  
**Producto:** Sistema multiplataforma de inventario y panel administrativo  
**Plataformas iniciales:** Android + Windows + Landing Web  
**Stack base:** Flutter + Dart + Supabase + Riverpod + go_router  

---

## 0. Propósito de este documento
Este documento define la visión funcional, técnica y comercial de **Inventra**, y debe utilizarse como **fuente maestra** para diseño, desarrollo, QA, pruebas, despliegue y evolución del producto.

Su objetivo es:
- alinear producto, arquitectura y desarrollo
- servir como base para generar el proyecto en Antigravity
- definir alcance MVP y expansión futura
- evitar improvisaciones estructurales
- mantener una sola fuente de verdad

Este documento **no es académico**. Debe tratarse como especificación viva del producto.

---

## 1. Resumen ejecutivo
**Inventra** es una solución multiplataforma para **gestión de inventario y administración operativa**, diseñada para pequeñas y medianas organizaciones que necesitan controlar productos, categorías, movimientos de stock, usuarios, roles, reportes y configuraciones desde una aplicación moderna y clara.

El producto nace como:
- **app de escritorio para Windows** orientada a administración operativa
- **app móvil Android** orientada a operación rápida
- **landing web pública** para presentar el producto, mostrar funciones y ofrecer descarga

Inventra se construirá con una sola base principal en **Flutter**, conectada a **Supabase** como plataforma de datos, autenticación, almacenamiento y sincronización.

---

## 2. Problema y oportunidad

### 2.1 Problema
Muchos negocios pequeños y medianos todavía gestionan inventario mediante:
- cuadernos
- hojas de Excel
- mensajes por WhatsApp
- registros dispersos
- sistemas viejos difíciles de usar

Esto genera:
- errores en stock
- pérdida de tiempo
- falta de trazabilidad
- mala visibilidad del inventario real
- dificultad para auditar cambios
- dependencia de una sola persona que “sabe cómo está todo”

### 2.2 Oportunidad
Existe una oportunidad clara en ofrecer una herramienta:
- fácil de usar
- moderna
- rápida
- usable en escritorio y móvil
- preparada para crecer
- con control por usuarios y roles
- con reportes y trazabilidad

El valor aumenta si el sistema combina:
- simplicidad operativa
- arquitectura sólida
- experiencia multiplataforma
- diseño claro y accesible
- posibilidad de evolución futura hacia panel administrativo más completo

---

## 3. Visión del producto

### 3.1 Visión
Convertir a **Inventra** en una solución multiplataforma confiable, moderna y escalable para administrar inventario y operación básica sin complejidad innecesaria.

### 3.2 Objetivos estratégicos
- lanzar un **MVP funcional y presentable**
- demostrar arquitectura profesional para portafolio y CV
- permitir uso real en pequeños negocios o pruebas piloto
- dejar la base preparada para:
  - reportes avanzados
  - auditoría
  - roles y permisos
  - sucursales
  - exportación
  - crecimiento comercial futuro

### 3.3 Objetivos de producto
- facilitar registro de productos y stock
- registrar entradas y salidas de inventario
- permitir consulta rápida desde móvil y escritorio
- centralizar información en tiempo real
- mostrar reportes claros
- controlar usuarios y permisos
- minimizar errores manuales

---

## 4. Tipo de producto
**Inventra** será un **panel administrativo con inventario**.

No es solo una lista de productos.  
Debe incluir una capa de administración con:
- dashboard
- módulos de gestión
- control de usuarios
- roles
- reportes
- configuraciones
- trazabilidad operativa

---

## 5. Segmentos de usuario objetivo

### 5.1 Negocios objetivo iniciales
- bodegas y tiendas
- pequeños comercios
- negocios familiares
- restaurantes pequeños
- emprendimientos con almacén
- locales con reposición manual
- negocios que hoy usan Excel o cuaderno

### 5.2 Perfiles de usuario
- **Administrador**
  - controla sistema, usuarios, configuración, reportes
- **Operador**
  - registra entradas/salidas, consulta productos, actualiza stock
- **Supervisor**
  - revisa movimientos, consulta reportes, valida operaciones si aplica

---

## 6. Propuesta de valor
Inventra ofrecerá:
- inventario centralizado
- acceso desde escritorio y móvil
- panel administrativo simple
- mejor control del stock
- trazabilidad de movimientos
- roles y permisos
- experiencia moderna y accesible
- base preparada para escalar

---

## 7. Alcance por fases

### Fase 1 — MVP
Incluye:
- autenticación
- dashboard básico
- gestión de productos
- gestión de categorías
- stock actual
- movimientos de inventario
- usuarios básicos
- perfil
- reportes básicos
- configuración mínima del negocio

### Fase 2 — Operación administrada
Incluye:
- roles y permisos mejorados
- historial de movimientos
- alertas de stock bajo
- imágenes de productos
- filtros avanzados
- soporte para sucursal única ampliada

### Fase 3 — Panel más robusto
Incluye:
- múltiples sucursales
- auditoría
- actividad por usuario
- exportación CSV/PDF
- dashboards mejorados
- configuraciones avanzadas

### Fase 4 — Evolución comercial
Incluye:
- multiempresa
- suscripciones
- módulos premium
- analítica avanzada
- automatizaciones
- integraciones futuras

---

## 8. Módulos funcionales
1. Identidad y acceso  
2. Dashboard administrativo  
3. Productos  
4. Categorías  
5. Inventario / stock  
6. Movimientos de inventario  
7. Usuarios  
8. Roles y permisos  
9. Reportes  
10. Configuración  
11. Auditoría futura  
12. Landing web pública  

---

## 9. Plataformas del sistema

### 9.1 Aplicación móvil Android
Uso esperado:
- registrar movimientos rápidos
- consultar stock
- buscar productos
- revisar alertas
- operar en campo o almacén

### 9.2 Aplicación de escritorio Windows
Uso esperado:
- administración diaria
- configuración del sistema
- reportes
- gestión de usuarios
- revisión de stock y movimientos
- operaciones con tablas grandes

### 9.3 Landing web pública
Uso esperado:
- presentar el producto
- mostrar beneficios y capturas
- ofrecer descarga de la app de escritorio
- redirigir a Play Store
- servir como página de producto/portafolio

---

## 10. Arquitectura funcional de alto nivel
El sistema estará compuesto por:

### Cliente Flutter
- app Android
- app Windows
- misma base de código principal
- UI adaptativa por plataforma

### Backend/BaaS
- Supabase PostgreSQL
- Supabase Auth
- Supabase Storage
- Supabase Realtime
- RLS para control de acceso

### Sitio público
- landing desacoplada
- sin lógica administrativa crítica
- solo presentación, capturas, descargas y CTA

---

## 11. Reglas de negocio base
- cada producto pertenece a una categoría
- el stock actual se calcula o consolida desde movimientos válidos
- todo movimiento de inventario debe registrar:
  - tipo
  - cantidad
  - fecha
  - actor
  - producto
- no se permiten cantidades negativas inválidas
- toda modificación crítica debe quedar trazada cuando auditoría esté activa
- el acceso a datos debe depender del rol del usuario
- un operador no debe poder acceder a configuraciones administrativas sensibles
- un producto puede tener estado activo o inactivo
- una categoría puede deshabilitarse sin borrar historial
- los reportes no deben alterar datos operativos

---

## 12. Roles del sistema

### 12.1 Administrador
Permisos:
- gestionar productos
- gestionar categorías
- gestionar usuarios
- gestionar roles básicos
- ver dashboard
- ver reportes
- cambiar configuración general

Restricciones:
- no debe eliminar trazabilidad histórica sensible

### 12.2 Supervisor
Permisos:
- consultar productos
- consultar movimientos
- ver reportes
- apoyar control operativo

Restricciones:
- sin control total de configuración
- sin acceso a operaciones críticas de plataforma

### 12.3 Operador
Permisos:
- registrar entradas y salidas
- consultar inventario
- actualizar datos limitados según permiso

Restricciones:
- no gestiona usuarios
- no cambia configuración global
- no accede a reportes avanzados si no corresponde

---

## 13. Requerimientos funcionales

| ID | Prioridad | Descripción |
|---|---|---|
| RF-001 | Alta | Permitir inicio de sesión con correo y contraseña. |
| RF-002 | Alta | Permitir recuperación de contraseña. |
| RF-003 | Alta | Mostrar dashboard inicial con métricas básicas. |
| RF-004 | Alta | Crear, editar, listar y desactivar productos. |
| RF-005 | Alta | Crear, editar, listar y desactivar categorías. |
| RF-006 | Alta | Registrar movimientos de entrada de stock. |
| RF-007 | Alta | Registrar movimientos de salida de stock. |
| RF-008 | Alta | Consultar stock actual por producto. |
| RF-009 | Alta | Buscar productos por nombre, categoría o código. |
| RF-010 | Media | Adjuntar imagen de producto. |
| RF-011 | Media | Visualizar historial de movimientos por producto. |
| RF-012 | Alta | Gestionar usuarios del sistema según rol. |
| RF-013 | Media | Gestionar roles y permisos básicos. |
| RF-014 | Alta | Generar reportes básicos por periodo. |
| RF-015 | Media | Mostrar alertas de stock bajo. |
| RF-016 | Media | Mostrar actividad reciente en dashboard. |
| RF-017 | Media | Configurar datos básicos del negocio. |
| RF-018 | Baja | Exportar datos a CSV/PDF en fases posteriores. |
| RF-019 | Baja | Preparar base para auditoría avanzada. |
| RF-020 | Baja | Preparar base para múltiples sucursales. |

---

## 14. Requerimientos no funcionales

| ID | Categoría | Criterio |
|---|---|---|
| RNF-001 | Rendimiento | Navegación principal fluida en móvil y escritorio. |
| RNF-002 | Rendimiento | Operaciones comunes con respuesta razonable en redes normales. |
| RNF-003 | Seguridad | Acceso controlado por autenticación y RLS. |
| RNF-004 | Seguridad | No exponer claves sensibles en cliente. |
| RNF-005 | Usabilidad | Registro y consulta de inventario comprensibles para usuario no técnico. |
| RNF-006 | Accesibilidad | Vistas principales diseñadas con criterios razonables de accesibilidad. |
| RNF-007 | Escalabilidad | Estructura preparada para crecer a módulos más avanzados. |
| RNF-008 | Mantenibilidad | Código modular, tipado y organizado por features/capas. |
| RNF-009 | Calidad | Pruebas mínimas en lógica crítica y flujos esenciales. |
| RNF-010 | Observabilidad | Manejo de errores y registro básico de eventos críticos. |

---

## 15. Experiencia de usuario
La UX debe priorizar:
- rapidez
- claridad
- baja curva de aprendizaje
- tareas frecuentes bien visibles
- navegación limpia
- formularios simples
- mensajes claros
- diseño adaptable entre escritorio y móvil

### Principios UX
- primero lo importante
- sin ruido visual innecesario
- acciones críticas visibles
- validaciones claras
- estados de carga/error/empty siempre presentes
- feedback inmediato tras operaciones

---

## 16. Accesibilidad
Inventra debe considerar accesibilidad desde el inicio.

### Objetivos
- textos legibles
- contraste suficiente
- navegación coherente
- botones claros
- formularios comprensibles
- foco visible
- etiquetas descriptivas
- no depender solo del color
- tamaños táctiles razonables en móvil

### Meta
Apuntar a una base razonable alineada a buenas prácticas de accesibilidad para interfaces modernas.

---

## 17. ODS 10 — Reducción de desigualdades
Inventra incorporará criterios prácticos vinculados a inclusión digital:
- interfaz comprensible para usuarios con poca experiencia técnica
- baja fricción operativa
- compatibilidad con dispositivos modestos
- diseño claro en escritorio y móvil
- lenguaje simple
- reducción de barreras de uso
- foco en facilidad operativa para pequeños negocios

Esto no será decorativo: se traducirá en decisiones de UX, rendimiento y claridad del sistema.

---

## 18. Arquitectura técnica propuesta

### 18.1 Stack base
- **Flutter**
- **Dart**
- **Riverpod**
- **go_router**
- **Supabase**
- **PostgreSQL**
- **Supabase Auth**
- **Supabase Storage**
- **Supabase Realtime**

### 18.2 Motivos del stack
- una sola base principal para Android y Windows
- experiencia moderna
- buena mantenibilidad
- backend acelerado con Supabase
- estructura limpia con Riverpod
- navegación robusta con go_router

### 18.3 Estilo arquitectónico
Arquitectura modular por features con separación en:
- presentación
- estado
- dominio
- datos

---

## 19. Modelo de datos inicial

### 19.1 Entidades principales
- users / profiles
- roles
- permissions
- categories
- products
- inventory_movements
- inventory_stock
- settings
- audit_logs (fase futura)
- branches (fase futura)

### 19.2 Descripción de tablas

#### profiles
- id
- full_name
- email
- role_id
- is_active
- created_at
- updated_at

#### roles
- id
- name
- description

#### categories
- id
- name
- description
- is_active
- created_at
- updated_at

#### products
- id
- name
- sku
- category_id
- description
- image_url
- min_stock
- is_active
- created_at
- updated_at

#### inventory_movements
- id
- product_id
- movement_type
- quantity
- reason
- created_by
- created_at

#### inventory_stock
- id
- product_id
- current_quantity
- updated_at

#### settings
- id
- business_name
- currency
- timezone
- updated_at

---

## 20. Seguridad
La seguridad es obligatoria desde el inicio.

### Medidas base
- autenticación con Supabase Auth
- Row Level Security
- control por rol
- validación de formularios
- manejo seguro de sesiones
- secretos fuera del cliente
- reglas server-side para operaciones sensibles si aplica
- archivos protegidos con políticas adecuadas
- logs de errores sin filtrar datos sensibles

### Principios
- mínimo privilegio
- separación de acceso por rol
- nada sensible hardcodeado
- validación en cliente y en capa de datos/proceso

---

## 21. Calidad y pruebas

### Estrategia mínima
- pruebas unitarias de lógica
- pruebas de widgets clave
- pruebas de integración para login y CRUD principal
- linting
- revisión manual de navegación
- pruebas de estados de error y carga

### Definition of Done mínima
Una funcionalidad solo se considera terminada si:
- compila
- no rompe arquitectura
- maneja loading/error/empty
- respeta diseño base
- tiene validaciones
- incluye pruebas donde corresponda
- queda integrada a navegación y permisos

---

## 22. Observabilidad y errores
- manejo centralizado de errores
- mensajes de error útiles para usuario
- logs técnicos controlados
- evitar silencios ante fallos
- diferenciar errores de red, validación y permisos

---

## 23. Landing web
La landing debe incluir:
- hero principal
- descripción del producto
- beneficios
- capturas
- funciones
- plataformas
- descarga Windows
- enlace a Play Store
- contacto/demo
- FAQ
- secciones de seguridad, accesibilidad y enfoque de producto

---

## 24. Roadmap del producto

### 0–1 mes
- setup del proyecto
- arquitectura base
- navegación
- autenticación
- diseño base

### 1–2 meses
- productos
- categorías
- movimientos
- stock
- dashboard básico

### 2–3 meses
- usuarios
- roles básicos
- reportes
- configuración

### 3–4 meses
- alertas
- imágenes
- mejoras UX
- endurecimiento técnico

### 4–6 meses
- auditoría
- exportaciones
- mejoras de escritorio
- mejoras móviles
- base para sucursales

---

## 25. Riesgos principales
- intentar hacer demasiados módulos al inicio
- mezclar lógica de negocio con UI
- no definir bien permisos
- no cuidar estados visuales
- depender de atajos inseguros
- no planear crecimiento
- complicar demasiado la landing
- subestimar sincronización entre móvil y escritorio

---

## 26. Suposiciones
- el proyecto inicial será desarrollado por una sola persona con apoyo de IA
- el idioma principal será español
- el enfoque inicial será Android + Windows
- la landing será informativa antes que comercial compleja
- Supabase será suficiente para el MVP
- la monetización no es prioridad inmediata, pero el sistema debe quedar presentable

---

## 27. Criterios de aceptación del MVP

| Código | Criterio |
|---|---|
| CA-01 | Un usuario puede iniciar sesión correctamente. |
| CA-02 | Un administrador puede crear y editar productos. |
| CA-03 | Un administrador puede crear y editar categorías. |
| CA-04 | Un operador autorizado puede registrar movimientos de entrada y salida. |
| CA-05 | El sistema refleja el stock actual de manera coherente. |
| CA-06 | Existen vistas útiles tanto en Windows como en Android. |
| CA-07 | El dashboard muestra información básica relevante. |
| CA-08 | La arquitectura permite continuar hacia módulos Intermedio/Pro. |
| CA-09 | La app mantiene organización clara y mantenible. |
| CA-10 | La landing presenta el producto y sus descargas. |

---

## 28. Backlog sugerido para Antigravity
- generar estructura Flutter base por features
- integrar Supabase Auth
- configurar go_router
- configurar Riverpod
- construir design system base
- crear módulo de login
- crear shell principal de dashboard
- crear módulo de categorías
- crear módulo de productos
- crear módulo de movimientos
- calcular stock
- crear módulo de usuarios
- crear ajustes básicos
- crear landing web de producto
- agregar pruebas base
- documentar setup local y despliegue

---

## 29. Prompt base para Antigravity
Desarrolla **Inventra** siguiendo este documento como fuente maestra.  
Prioriza una arquitectura limpia y escalable con **Flutter + Supabase**, usando **Riverpod** para estado, **go_router** para navegación y una estructura modular orientada a crecimiento.

Construye primero el MVP con:
- autenticación
- dashboard
- productos
- categorías
- movimientos
- stock
- usuarios básicos
- reportes básicos
- configuración mínima
- landing web pública

Respeta:
- separación de responsabilidades
- mantenibilidad
- seguridad
- accesibilidad
- claridad visual
- crecimiento futuro a módulos Intermedio/Pro

No improvises estructuras frágiles ni acoples innecesarios.

---

## 30. Conclusión
**Inventra** debe construirse como un producto serio, multiplataforma, mantenible y presentable.  
La meta no es solo “hacer que funcione”, sino crear una base técnica y funcional sólida que pueda:
- usarse
- mostrarse en portafolio
- evolucionar
- escalar en complejidad sin romperse

Este documento será la guía principal para construir el sistema.
