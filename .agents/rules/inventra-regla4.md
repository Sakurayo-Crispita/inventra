---
trigger: always_on
---

# Regla 04 — Estructura de código, capas y convenciones

## Feature-first obligatorio
La app debe organizarse por módulos funcionales, no por tipos de archivo mezclados globalmente.

## Separación obligatoria por capas
Cada feature debe respetar estas funciones:

### Presentation
Sí:
- pages
- screens
- widgets
- dialogs
- forms

No:
- queries directas
- SQL
- lógica de negocio compleja
- acceso crudo a SDK externos

### Application
Sí:
- providers
- notifiers
- acciones asincrónicas
- coordinación de flujos
- estado

No:
- widgets
- render visual
- acoplamiento innecesario al SDK externo

### Domain
Sí:
- entidades
- contratos
- reglas
- casos de uso

No:
- dependencias de Flutter UI
- Supabase SDK
- widgets

### Data
Sí:
- repositorios
- datasources
- DTOs
- mappers
- acceso a Supabase

No:
- lógica visual
- widgets
- dependencias innecesarias hacia presentation

## Wrappers obligatorios
Cualquier integración externa importante debe pasar por wrapper o servicio intermedio.

Especialmente para:
- auth
- storage
- realtime
- queries principales

Objetivo:
Si cambia la implementación, no debe romperse toda la app.

## Naming
Usar nombres explícitos.

Bien:
- `createProduct`
- `inventoryMovementsProvider`
- `fetchActiveCategories`
- `AuthGuard`

Mal:
- `doStuff`
- `tmp`
- `dataX`

## Convenciones
- archivos: `snake_case`
- clases: `PascalCase`
- variables/funciones: `camelCase`

## Inmutabilidad
Usar modelos inmutables por defecto siempre que sea razonable.

## Cambios atómicos
Cada cambio debe ser:
- funcional
- coherente
- compilable
- explicable

No dejar piezas críticas a medio hacer.
