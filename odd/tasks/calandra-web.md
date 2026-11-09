# Calandra Moda — sitio institucional (feature/calandra-web)

## Objetivo

Construir el sitio institucional de Calandra Moda (boutique de vestidos en Lanús Este): una landing
editorial completa, estática, rápida y accesible, cuya conversión principal es iniciar una
conversación por WhatsApp, sin inventar datos comerciales.

## Problema

La boutique no tenía presencia web. Necesita transmitir el diferencial de atención personalizada y
asesoramiento, mostrar sus tres especialidades (novias, fiesta y casamiento, celebraciones), ubicar la
tienda en Lanús y habilitar el contacto por WhatsApp, con una estética de alta costura y no de tienda
genérica.

## Alcance

- Landing de una página con secciones A–I del brief + bloque de preguntas frecuentes (AEO).
- Página 404.
- Sitio 100% estático (SSG) con Astro, sin React, sin base de datos.
- Datos de contacto centralizados y con estado "pendiente" explícito cuando no están confirmados.
- SEO técnico, GEO y AEO con JSON-LD validado.

## Fuera de alcance

- Publicación en producción y merge a la rama principal.
- Fichas de producto, e-commerce o pasarela de pagos.
- Inventar teléfono, horarios, precios, reseñas, marcas o servicios.
- Fotografías reales (se entregan placeholders de marca identificados).

## Restricciones

- No alquiler: la comunicación habla de **venta** de vestidos.
- Sin números inventados: los CTA usan WhatsApp sólo si `WHATSAPP_NUMBER` está configurado.
- Dominio provisorio documentado en tres ubicaciones.
- Estética: marfil, champagne, arena, negro suave, dorado discreto; serif editorial + sans.
- Objetivos: Lighthouse Performance 90+, SEO 95+, A11y 90+, Best Practices 95+.

## Tareas

| ID | Tarea | Ruta | Estado | Evidencia |
| --- | --- | --- | --- | --- |
| T1 | Inicializar repo, rama `feature/calandra-web`, Astro 7 + TS + Tailwind 4 | Inline | Hecho | `npm run build` OK |
| T2 | Generar imágenes provisorias de marca (script reproducible) | Inline | Hecho | 14 JPG + OG PNG en `src/assets/images` y `public/images` |
| T3 | Definir sistema de diseño (tokens, tipografía, botones, filetes) | Inline | Hecho | `src/styles/global.css` |
| T4 | Centralizar datos del negocio, navegación y mensajes de WhatsApp | Inline | Hecho | `src/data/site.ts` |
| T5 | Estructurar galería y textos alternativos por slot | Inline | Hecho | `src/data/gallery.ts` |
| T6 | Implementar Header responsive (details, sin JS obligatorio) | Inline | Hecho | Screenshot móvil con menú abierto |
| T7 | Implementar Hero, Categorías, CTA de categorías | Inline | Hecho | Screenshots 1440/390/320 |
| T8 | Implementar Experiencia, Galería editorial, Historia | Inline | Hecho | Screenshots de secciones |
| T9 | Implementar FAQ, CTA final, Contacto, Footer, botón flotante | Inline | Hecho | Screenshots de secciones |
| T10 | SEO: canonical, OG, Twitter, sitemap, robots, 404 noindex | Inline | Hecho | Script de verificación de build (35 chequeos) |
| T11 | JSON-LD: ClothingStore, WebSite, FAQPage | Inline | Hecho | Parseo + asserts sin datos inventados |
| T12 | AEO: FAQs visibles + `llms.txt` | Inline | Hecho | Lighthouse agentic-browsing 100 |
| T13 | Optimización de imágenes (WebP, srcset, preload de fuentes) | Inline | Hecho | CLS 0, LCP 0.8 s local |
| T14 | Verificación de tipos, build, responsive y accesibilidad | Inline + Lighthouse | Hecho | `astro check` 0 errores; Lighthouse 100/100/100/100 |
| T15 | Documentación (README, PENDIENTES) | Inline | Hecho | Archivos en la raíz |
| T16 | Fotografías de prueba CC0 rotuladas para mostrar la maqueta completa | Inline | Hecho | 14 JPG recortados + `CREDITS.md` + barra global + etiqueta por imagen |

Nota de proceso: la implementación se ejecutó como un único hilo de escritura (sistema de diseño
coherente entre las 14 secciones), y la verificación se hizo con herramientas externas
(Chrome headless + Lighthouse + script de auditoría del build). Los chequeos se repitieron después de
cada corrección.

## Decisiones y justificación breve

- **SSG sin adapter de Vercel:** no hay rutas dinámicas ni backend; el adapter sería una dependencia
  innecesaria.
- **`ClothingStore` en lugar de `LocalBusiness` genérico:** es el subtipo específico de Schema.org para
  una boutique de indumentaria y hereda de `LocalBusiness` y `Organization`.
- **Sin `BreadcrumbList`:** el sitio es una única página sin jerarquía de URLs; un breadcrumb sería
  semánticamente vacío.
- **WhatsApp con fallback a `/#contacto`:** mantiene todos los CTA navegables y sin números inventados.
- **Placeholders JPEG generados:** se pueden reemplazar por fotografías autorizadas sin tocar código y
  permiten demostrar el pipeline de `astro:assets`.
- **Menú móvil con `<details>`:** funciona sin JavaScript; el script solo cierra el panel al navegar.
- **Sin animaciones de entrada:** protege LCP y evita contenido oculto si falla JavaScript. **Fotografías de prueba CC0:** permiten ver la maqueta terminada sin usar material de otras boutiques; se rotulan en la barra superior, en cada imagen, en la galería, en el pie y en los `alt`, y se desactivan con `usingTestImages = false`.

## Verificación

- `npm run check`: 0 errores, 0 warnings.
- `npm run build`: 2 páginas, 54 variantes de imagen generadas.
- Overflow horizontal: 0 px en 1440, 834, 390 y 320.
- Anclas internas: todas resuelven (incluida la 404).
- Imágenes: 14/14 con `alt`, `width`, `height` y `loading`.
- JSON-LD: parsea, 3 nodos, sin teléfono/horarios/rating.
- Lighthouse (build de producción, perfil móvil): Performance 100 · A11y 100 · Best Practices 100 · SEO 100 (con fotografías de prueba, 691 KiB totales).

## Siguiente paso

Revisión del cliente sobre textos y placeholders; luego completar `PENDIENTES.md` (WhatsApp, Instagram,
horarios, dominio, logo y fotografías) y desplegar en Vercel.
