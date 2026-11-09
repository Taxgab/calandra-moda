# Calandra Moda — Sitio institucional

Landing page de **Calandra Moda**, boutique de vestidos de novia, fiesta y casamiento en Lanús Este,
Buenos Aires. Sitio institucional de una sola página, con foco en la conversión por WhatsApp.

- **Stack:** Astro 7 (SSG) · TypeScript · Tailwind CSS 4 · Lucide Icons · `astro:assets`
- **Deploy:** Vercel (sitio estático, sin servidor ni base de datos)
- **Rama de trabajo:** `feature/calandra-web`

---

## Requisitos

- Node.js `>= 22.23.4`
- npm

## Puesta en marcha

```bash
npm install       # instalar dependencias
npm run dev       # servidor local en http://localhost:4321
npm run build     # build de producción en dist/
npm run preview   # sirve el resultado del build
npm run check     # verificación de tipos (astro check)
npm run placeholders  # regenera las imágenes provisorias de marca
```

---

## Estructura

```
src/
  assets/images/        Fotografías del sitio (hoy: provisorias)
  components/           Header, Hero, Categories, Experience, Gallery, Story,
                        Faq, FinalCta, Contact, Footer, WhatsAppCta,
                        WhatsAppFloat, SEO, SectionIntro, CategoryCard
  data/
    site.ts             Datos del negocio, navegación, mensajes de WhatsApp, SEO base
    gallery.ts          Imágenes y estructura de la galería editorial
    faq.ts              Preguntas frecuentes (fuente única visible + Schema.org)
  layouts/
    BaseLayout.astro    Documento HTML, fuentes, header/footer y slot de contenido
  lib/
    structured-data.ts  Nodos JSON-LD (ClothingStore, WebSite, FAQPage)
  pages/
    index.astro         Landing completa
    404.astro           Página de error
  styles/
    global.css          Tokens de diseño, tipografía y utilidades editoriales
public/
  favicon.svg
  robots.txt
  llms.txt              Resumen del negocio para asistentes de IA (AEO)
  images/og-cover.png   Imagen de Open Graph / Twitter Cards
scripts/
  generate-placeholders.ps1   Generador de imágenes provisorias (Windows, System.Drawing)
```

---

## Edición de contenido

Todos los datos viven en un único lugar. **No repetir datos de contacto en componentes.**

| Qué quiero cambiar | Archivo |
| --- | --- |
| Nombre, dirección, Instagram, WhatsApp, metadatos SEO | `src/data/site.ts` |
| Mensajes iniciales de WhatsApp por sección | `src/data/site.ts` → `whatsappMessages` |
| Preguntas frecuentes (visibles y Schema.org) | `src/data/faq.ts` |
| Imágenes, orden y textos alternativos de la galería | `src/data/gallery.ts` |
| Textos de secciones | Componentes en `src/components/` |
| Paleta, tipografía y espaciados | `src/styles/global.css` (`@theme`) |

### Activar WhatsApp

En `src/data/site.ts`, completar el número en formato internacional, sin `+`, espacios ni guiones:

```ts
const WHATSAPP_NUMBER = '5491122334455';
```

Con el número configurado, todos los CTA abren `https://wa.me/...` con un mensaje contextual según
la sección de origen. Mientras esté vacío, los CTA apuntan a `/#contacto` (no se rompe ningún enlace).

### Activar Instagram

En `src/data/site.ts`, completar el perfil:

```ts
contact: {
  instagramHandle: '@calandramoda',
  instagramUrl: 'https://www.instagram.com/calandramoda',
}
```

Si está vacío, la interfaz muestra el canal como "pendiente" en lugar de un enlace roto.

### Cambiar el dominio definitivo

Tres lugares:

1. `astro.config.mjs` → `site`
2. `src/data/site.ts` → `SITE_URL`
3. `public/robots.txt` → línea `Sitemap:`

Luego `npm run build` para regenerar el sitemap.

---

## Imágenes

Las fotografías actuales son **placeholders de marca generados localmente** (no son fotos de otras
boutiques). Se identifican como provisorias en la propia imagen y en la sección de galería.

Para reemplazarlas por material autorizado del cliente:

1. Guardar la fotografía en `src/assets/images/` con **el mismo nombre de archivo** y una proporción
   similar (por ejemplo `hero.jpg`, `gallery-novias-01.jpg`).
2. Actualizar el `alt` correspondiente en `src/data/gallery.ts`.
3. Correr `npm run build`.

Astro genera versiones WebP en varios anchos, con `width`/`height` explícitos (sin CLS) y lazy
loading salvo en el hero.

Regenerar los placeholders: `npm run placeholders` (requiere Windows con .NET/System.Drawing).

---

## SEO, GEO y AEO

- Titles y meta descriptions únicos, canonical, Open Graph y Twitter Cards.
- Sitemap automático con `@astrojs/sitemap` y `robots.txt`.
- HTML semántico: un `H1`, un `H2` por sección, `H3` en tarjetas, pasos y preguntas.
- Imágenes optimizadas con `alt` descriptivo y dimensiones explícitas.
- JSON-LD: `ClothingStore` (subtipo de `LocalBusiness` y `Organization`), `WebSite` y `FAQPage`.
- Sin datos inventados: no se declaran teléfono, horarios, precios, reseñas ni valoraciones.
- `public/llms.txt` con identidad, ubicación, páginas y respuestas para asistentes de IA.

---

## Rendimiento y accesibilidad

Medición local con Lighthouse (build de producción, perfil móvil por defecto):

| Categoría | Resultado |
| --- | --- |
| Performance | 100 |
| Accessibility | 100 |
| Best Practices | 100 |
| SEO | 100 |

Incluye: fuentes autoalojadas con subset latino y `preload`, CSS crítico inline, imágenes WebP con
`srcset`, foco visible, contraste AA, `prefers-reduced-motion` y navegación sin dependencia de JS
(el menú móvil usa `<details>`; el JavaScript solo lo cierra al navegar).

---

## Deploy en Vercel

1. Subir el repositorio a GitHub (`feature/calandra-web` puede mergearse a la rama principal cuando el
   cliente apruebe).
2. En Vercel: **Add New → Project → Import Git Repository**.
3. Configuración detectada automáticamente:
   - Framework preset: **Astro**
   - Build command: `npm run build`
   - Output directory: `dist`
   - Install command: `npm install`
4. Node.js: seleccionar **22.x** o superior.
5. Deploy. Cada push a la rama genera un preview; la rama principal publica en producción.
6. Al confirmar el dominio definitivo: agregarlo en Vercel, actualizar los tres valores del punto
   "Cambiar el dominio definitivo" y volver a desplegar.

No se requiere adapter de Vercel ni variables de entorno: el sitio es completamente estático.

---

## Datos pendientes del cliente

Ver [`PENDIENTES.md`](./PENDIENTES.md).
