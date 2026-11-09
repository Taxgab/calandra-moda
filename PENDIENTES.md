# Datos pendientes de confirmación

El sitio está construido sin inventar información comercial. Todo lo que falta está parametrizado y
se activa completando los valores indicados.

| Dato | Estado en el sitio | Dónde se carga | Efecto al completarlo |
| --- | --- | --- | --- |
| **Número de WhatsApp** | Los CTA apuntan a `/#contacto` y el bloque de contacto informa "Número de WhatsApp pendiente de confirmación". | `src/data/site.ts` → `WHATSAPP_NUMBER` (formato `5491122334455`, sin `+`, espacios ni guiones) | Todos los botones abren WhatsApp con mensaje contextual por sección. |
| **Perfil de Instagram** | Se muestra el canal como "pendiente" (sin enlace). | `src/data/site.ts` → `contact.instagramHandle` y `contact.instagramUrl` | Aparece el enlace al perfil en contacto y footer. |
| **Horarios de atención** | No se publican. El bloque de contacto aclara que se publican al confirmarse. | `src/data/site.ts` → `hours` (y agregar el bloque visible en `Contact.astro`) | Se puede mostrar el horario en la sección de contacto y sumarlo a los datos estructurados. |
| **Dominio definitivo** | Provisoriamente `https://www.calandramoda.com.ar`. | `astro.config.mjs` → `site`, `src/data/site.ts` → `SITE_URL`, `public/robots.txt` | Canonical, Open Graph, sitemap y JSON-LD quedan con la URL real. |
| **Logotipo en alta calidad** | Wordmark tipográfico provisorio (serif + "MODA" en versalitas). | Reemplazar por SVG en `src/components/Header.astro`, `Footer.astro` y `public/favicon.svg` | Identidad visual definitiva. |
| **Fotografías reales autorizadas** | Fotografías de prueba CC0 (StockSnap) rotuladas en la página, en cada imagen y en los `alt`; se desactivan con `usingTestImages = false`. | `src/assets/images/` (mismo nombre de archivo) + `alt` en `src/data/gallery.ts` | Imágenes reales optimizadas automáticamente a WebP, sin rótulos de maqueta. |
| **Correo electrónico de contacto** | No se publica. | `src/data/site.ts` → `contact.email` | Disponible para sumar al canal de contacto. |
| **Texto institucional definitivo** | Redacción provisoria basada en los datos confirmados (rubro, especialidades, +20 años, dirección). | `src/components/Story.astro` y `src/components/Experience.astro` | Ajuste de tono y detalles de trayectoria sin inventar hitos. |

## Datos que el sitio NO publica a propósito- Teléfono fijo o celular distinto del WhatsApp.
- Horarios, precios, promociones, financiación.
- Reseñas, valoraciones o cantidad de clientas.
- Marcas o diseñadores que la boutique comercialice.
- Servicios adicionales (ajustes, alquiler, reservas) que no fueron confirmados.

Cuando el cliente confirme alguno de estos datos, se agrega en el archivo indicado y se actualiza el
JSON-LD en `src/lib/structured-data.ts` si corresponde.
