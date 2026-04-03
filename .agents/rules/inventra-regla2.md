---
trigger: always_on
---

# Regla 02 — Stack y arquitectura obligatoria

## Stack obligatorio
Usa exclusivamente esta base:

- **Flutter**
- **Dart**
- **Riverpod**
- **go_router**
- **Supabase**
- **Supabase Auth**
- **Supabase Storage**
- **Supabase Realtime**

## Arquitectura obligatoria
La app debe seguir una arquitectura **feature-first** con capas internas.

### Estructura por feature
Cada feature debe dividirse en:
- `presentation`
- `application`
- `domain`
- `data`

### Significado de capas
**presentation**
- pantallas
- widgets
- componentes visuales
- formularios
- estados visuales

**application**
- providers
- notifiers
- coordinación de casos de uso
- estado derivado
- orquestación entre UI y dominio

**domain**
- entidades
- contratos
- reglas de negocio
- casos de uso

**data**
- repositorios concretos
- datasources
- DTOs
- mappers
- integración con Supabase

## Regla principal
Nunca mezclar en el mismo archivo:
- UI
- lógica de negocio
- acceso a datos
- configuración externa

## Estructura base sugerida
```text
lib/
  core/
    constants/
    errors/
    routing/
    services/
    theme/
    utils/
    widgets/
  features/
    auth/
      presentation/
      application/
      domain/
      data/
    dashboard/
      presentation/
      application/
      domain/
      data/
    products/
      presentation/
      application/
      domain/
      data/
    categories/
      presentation/
      application/
      domain/
      data/
    inventory/
      presentation/
      application/
      domain/
      data/
    users/
      presentation/
      application/
      domain/
      data/
    settings/
      presentation/
      application/
      domain/
      data/
```

## Reglas de crecimiento
- si algo solo sirve a una feature, vive dentro de esa feature
- si algo se reutiliza genuinamente entre varias, puede ir a `core`
- no crear carpetas genéricas tipo `misc`, `helpers` o `common` sin criterio

## Adaptación multiplataforma
Inventra debe adaptarse a:
- Android: flujos compactos, rápidos y táctiles
- Windows: tablas, paneles y administración más amplia

No duplicar toda la app por plataforma.  
Adaptar lo necesario con layouts y componentes apropiados.
