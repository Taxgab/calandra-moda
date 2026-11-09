/**
 * Datos del negocio y configuración del sitio.
 *
 * Única fuente de verdad para identidad, contacto, enlaces y metadatos.
 * Ningún componente debe repetir estos datos por su cuenta.
 *
 * Los valores marcados "PENDIENTE" todavía no fueron confirmados por el cliente.
 * Mientras estén vacíos, la interfaz muestra ese estado en lugar de inventar
 * información (teléfonos, redes, horarios o dominio).
 */

/**
 * Dominio provisorio.
 * PENDIENTE: reemplazar por el dominio definitivo antes de publicar.
 * Debe actualizarse también en astro.config.mjs y public/robots.txt.
 */
const SITE_URL = 'https://www.calandramoda.com.ar';

/**
 * Número de WhatsApp en formato internacional, sin "+", espacios ni guiones.
 * Ejemplo: 5491122334455 (54 Argentina · 9 celular · 11 área · número).
 * PENDIENTE: el cliente todavía no confirmó el número.
 */
const WHATSAPP_NUMBER = '';

/** Dirección de la boutique, tal como fue informada por el cliente. */
const ADDRESS = {
  venue: 'Gran Galería Lanús',
  street: 'Av. 9 de Julio 1126',
  locality: 'Lanús Este',
  region: 'Buenos Aires',
  country: 'Argentina',
  countryCode: 'AR',
} as const;

const MAPS_QUERY = encodeURIComponent(
  [ADDRESS.venue, ADDRESS.street, ADDRESS.locality, ADDRESS.region, ADDRESS.country].join(', '),
);

export const site = {
  name: 'Calandra Moda',
  legalName: 'Calandra Moda',
  tagline: 'Tu vestido. Tu momento. Nuestra experiencia.',
  /** Descripción corta: se usa en metadatos, footer y datos estructurados. */
  description:
    'Boutique de vestidos de novia, fiesta y casamiento en Lanús. Atención personalizada y asesoramiento para encontrar el vestido de tu gran momento.',
  url: SITE_URL,
  lang: 'es-AR',
  locale: 'es_AR',
  city: ADDRESS.locality,
  region: ADDRESS.region,
  country: ADDRESS.countryCode,
  /** Dato comercial confirmado por el cliente. */
  experienceYears: 20,
  experienceLabel: 'Más de 20 años de experiencia',
  address: {
    ...ADDRESS,
    /** Dirección completa en una línea, para mostrar y para datos estructurados. */
    full: `${ADDRESS.venue}, ${ADDRESS.street}, ${ADDRESS.locality}, ${ADDRESS.region}`,
    mapsUrl: `https://www.google.com/maps/search/?api=1&query=${MAPS_QUERY}`,
  },
  contact: {
    whatsappNumber: WHATSAPP_NUMBER,
    /** PENDIENTE: usuario de Instagram sin confirmar. */
    instagramHandle: '',
    /** PENDIENTE: perfil de Instagram sin confirmar. */
    instagramUrl: '',
    /** PENDIENTE: correo de contacto sin confirmar. */
    email: '',
  },
  /** PENDIENTE: los horarios de atención no fueron confirmados. */
  hours: [] as { days: string; hours: string }[],
  seo: {
    title: 'Calandra Moda | Vestidos de novia, fiesta y casamiento en Lanús',
    description:
      'Boutique de vestidos de novia, fiesta y casamiento en Lanús. Atención personalizada y asesoramiento para encontrar el vestido de tu gran momento.',
    ogImage: '/images/og-cover.png',
    ogImageAlt: 'Calandra Moda — boutique de vestidos en Lanús, Buenos Aires',
  },
} as const;

/**
 * Navegación principal. Los enlaces apuntan a secciones reales de la landing y
 * son absolutos desde la raíz para que también funcionen desde la página 404.
 */
export const navigation = [
  { label: 'Inicio', href: '/#inicio' },
  { label: 'Novias', href: '/#galeria-novias' },
  { label: 'Fiesta', href: '/#galeria-fiesta' },
  { label: 'Nuestra experiencia', href: '/#experiencia' },
  { label: 'Contacto', href: '/#contacto' },
] as const;

/**
 * Mensajes iniciales de WhatsApp por contexto.
 * Cada CTA abre la conversación con un texto acorde a la sección de origen.
 */
export const whatsappMessages = {
  header: 'Hola Calandra Moda, quiero consultar por WhatsApp.',
  hero: 'Hola Calandra Moda. Quiero recibir asesoramiento para elegir mi vestido.',
  categorias:
    'Hola Calandra Moda. No sé por dónde empezar y quiero asesoramiento para elegir mi vestido.',
  novias: 'Hola Calandra Moda. Quiero asesoramiento para un vestido de novia.',
  fiesta: 'Hola Calandra Moda. Quiero asesoramiento para un vestido de fiesta o casamiento.',
  celebraciones: 'Hola Calandra Moda. Quiero asesoramiento para un vestido de celebración.',
  experiencia:
    'Hola Calandra Moda. Quiero conocer cómo es la experiencia de elegir el vestido con ustedes.',
  galeria: 'Hola Calandra Moda. Vi la galería y quiero consultar por un vestido.',
  cta: 'Hola Calandra Moda. Quiero empezar a buscar el vestido para mi próximo gran momento.',
  contacto: 'Hola Calandra Moda. Quiero coordinar una consulta sobre vestidos.',
} as const;

export type WhatsAppContext = keyof typeof whatsappMessages;

/** true cuando el número de WhatsApp ya fue configurado. */
export const isWhatsAppConfigured = WHATSAPP_NUMBER.length > 0;

/** true cuando el perfil de Instagram ya fue configurado. */
export const isInstagramConfigured = site.contact.instagramUrl.length > 0;

/**
 * Enlace de WhatsApp con mensaje contextual.
 *
 * Si el número todavía no está configurado devuelve "/#contacto": el CTA sigue
 * siendo navegable (incluso desde la página 404) y la sección de contacto
 * explica el dato pendiente.
 */
export function whatsappUrl(context: WhatsAppContext): string {
  if (!isWhatsAppConfigured) return '/#contacto';
  return `https://wa.me/${WHATSAPP_NUMBER}?text=${encodeURIComponent(whatsappMessages[context])}`;
}

/** Enlace absoluto de una ruta interna, usado en metadatos y datos estructurados. */
export function absoluteUrl(path: string): string {
  return new URL(path, SITE_URL).toString();
}
