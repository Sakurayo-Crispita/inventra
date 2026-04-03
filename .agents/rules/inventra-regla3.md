---
trigger: always_on
---

# Regla 03 — Módulos y alcance funcional

## Orden de prioridad
Construir primero la base y luego los módulos en este orden:

1. auth
2. dashboard
3. categories
4. products
5. inventory
6. users
7. settings
8. landing web

## Módulos MVP obligatorios

### 1. Auth
Debe incluir:
- login
- logout
- sesión persistente
- recuperación de contraseña preparada o implementada

### 2. Dashboard
Debe incluir:
- métricas básicas
- actividad reciente básica
- accesos rápidos
- estado limpio y profesional

### 3. Categories
Debe incluir:
- listar
- crear
- editar
- desactivar

### 4. Products
Debe incluir:
- listar
- crear
- editar
- desactivar
- categoría asociada
- imagen opcional
- stock mínimo

### 5. Inventory
Debe incluir:
- movimientos de entrada
- movimientos de salida
- listado de movimientos
- stock actual coherente

### 6. Users
Debe incluir:
- listar usuarios
- crear o invitar si aplica
- activar/desactivar
- asignar rol base

### 7. Settings
Debe incluir:
- datos básicos del negocio
- moneda
- zona horaria
- parámetros mínimos visibles

### 8. Landing web
Debe incluir:
- hero principal
- propuesta de valor
- screenshots
- funciones
- plataformas
- descarga Windows
- enlace Play Store
- contacto/demo

## Reglas de negocio base
- cada producto pertenece a una categoría
- todo movimiento de inventario debe tener producto, tipo, cantidad, fecha y actor
- no permitir cantidades inválidas
- no usar eliminación destructiva cuando pueda resolverse con estado activo/inactivo
- el stock debe mantenerse coherente con movimientos válidos
- los reportes no modifican datos operativos

## Evolución futura
Dejar preparada la base para:
- auditoría
- exportación
- permisos más granulares
- múltiples sucursales
- dashboards avanzados
- módulos comerciales posteriores
