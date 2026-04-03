---
trigger: always_on
---

# Regla 06 — UI, calidad, seguridad y accesibilidad

## Sistema visual
Usar Material 3 como base con estilo moderno, limpio y consistente.

## Prohibido
- colores hardcodeados por toda la app
- tamaños mágicos repetidos
- pantallas gigantes monolíticas
- componentes sin estados límite

## Tokens recomendados
Centralizar:
- colores
- spacing
- radios
- tipografías
- elevaciones

## Componentización
Si un componente:
- se usa más de una vez, o
- supera tamaño razonable, o
- tiene complejidad visual notable

debe extraerse.

## Estados visuales obligatorios
Todo componente de datos debe manejar:
- loading
- error
- empty
- success
- data overflow

## Formularios
Todo formulario debe tener:
- validaciones claras
- labels visibles
- mensajes comprensibles
- feedback útil
- acciones bien nombradas

## Accesibilidad mínima
- contraste razonable
- textos legibles
- labels descriptivos
- foco visible
- tamaños táctiles adecuados
- no depender solo del color
- jerarquía visual clara

## ODS 10 aplicado
Diseñar para:
- usuarios no técnicos
- baja fricción operativa
- lectura rápida
- baja complejidad cognitiva
- dispositivos modestos

## Seguridad mínima obligatoria
- no hardcodear secretos
- no confiar solo en el cliente para permisos
- usar RLS
- proteger acceso por rol
- no imprimir tokens o datos sensibles
- validar entradas
- controlar errores sin exponer información sensible

## Calidad mínima
Antes de aceptar una funcionalidad, verificar:
- compila
- respeta arquitectura
- no rompe navegación
- maneja loading/error/empty
- usa diseño consistente
- tiene validaciones
- no mezcla UI y datos
- nombres claros
- pruebas básicas añadidas o actualizadas

## Qué probar primero
1. login/logout
2. carga de productos
3. creación/edición de productos
4. movimientos de inventario
5. stock coherente
6. guards de navegación
7. restricciones básicas por rol

## Meta-instrucción final
Antes de entregar cualquier cambio, evaluar:
1. ¿rompe arquitectura?
2. ¿mezcla responsabilidades?
3. ¿respeta Riverpod y go_router?
4. ¿es atómico y funcional?
5. ¿queda preparado para crecer?
6. ¿mantiene claridad visual y calidad?

Si alguna respuesta es negativa, refactorizar antes de dar el cambio por válido.
