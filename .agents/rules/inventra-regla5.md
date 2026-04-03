---
trigger: always_on
---

# Regla 05 — Estado, navegación y acceso a datos

## Riverpod es obligatorio
Todo estado importante debe manejarse con Riverpod.

Usar Riverpod para:
- auth
- dashboard
- categorías
- productos
- inventario
- usuarios
- settings
- filtros
- acciones asincrónicas

## Reglas de providers
- una responsabilidad clara por provider
- nombres explícitos
- dividir lectura, detalle, filtros y mutaciones si mejora claridad
- evitar providers gigantes

## Prohibido
- mezclar varios patrones de estado sin motivo
- meter lógica crítica en `setState`
- duplicar estado entre widgets y providers
- usar providers “Dios”

## go_router es obligatorio
Toda navegación principal debe centralizarse con `go_router`.

### Rutas base sugeridas
- `/login`
- `/dashboard`
- `/categories`
- `/products`
- `/products/new`
- `/inventory/movements`
- `/users`
- `/settings`

## Guards
La navegación debe:
- bloquear acceso a rutas privadas si no hay sesión
- redirigir correctamente
- respetar roles visibles cuando aplique

La navegación no reemplaza la seguridad real, pero sí debe reflejarla.

## Acceso a datos
Nunca consultar Supabase directamente desde widgets.

Siempre usar:
- datasource
- repositorio
- mapper
- provider/notifier

## Mapeo
Separar:
- DTO
- entidad de dominio
- modelo visual si hace falta

Ejemplo:
- `product_dto.dart`
- `product_mapper.dart`
- `product_entity.dart`

## Errores de datos
Centralizar y clasificar:
- red
- autenticación
- permisos
- validación
- error inesperado
