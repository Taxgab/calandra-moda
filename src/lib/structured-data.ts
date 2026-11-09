import type { FaqItem } from '../data/faq';
import { absoluteUrl, isInstagramConfigured, site } from '../data/site';

/**
 * Datos estructurados Schema.org (JSON-LD).
 *
 * Identidad de negocio local (GEO) + preguntas frecuentes (AEO).
 * No se declaran teléfonos, horarios, precios, reseñas ni valoraciones
 * porque no hay datos confirmados por el cliente.
 */

/** Nodo JSON-LD genérico. */
type JsonLdNode = Record<string, unknown>;

/** Nodo principal del negocio. ClothingStore es subtipo de LocalBusiness y Organization. */
export function buildStoreNode(): JsonLdNode {
  return {
    '@type': 'ClothingStore',
    '@id': `${site.url}/#store`,
    name: site.name,
    alternateName: 'Calandra Moda Boutique',
    description: site.description,
    url: site.url,
    image: absoluteUrl(site.seo.ogImage),
    logo: absoluteUrl('/favicon.svg'),
    slogan: site.tagline,
    address: {
      '@type': 'PostalAddress',
      streetAddress: `${site.address.venue}, ${site.address.street}`,
      addressLocality: site.address.locality,
      addressRegion: site.address.region,
      addressCountry: site.address.countryCode,
    },
    areaServed: {
      '@type': 'City',
      name: site.city,
    },
    hasMap: site.address.mapsUrl,
    knowsAbout: [
      'Vestidos de novia',
      'Vestidos de fiesta',
      'Vestidos de casamiento y celebración',
      'Asesoramiento en la elección del vestido',
      'Atención personalizada en boutique',
    ],
    // Los perfiles sociales se declaran solo cuando están confirmados.
    ...(isInstagramConfigured ? { sameAs: [site.contact.instagramUrl] } : {}),
  };
}

/** Nodo del sitio, con idioma y editor. */
export function buildWebsiteNode(): JsonLdNode {
  return {
    '@type': 'WebSite',
    '@id': `${site.url}/#website`,
    url: site.url,
    name: site.name,
    description: site.seo.description,
    inLanguage: site.lang,
    publisher: { '@id': `${site.url}/#store` },
  };
}

/** Nodo FAQPage construido desde la misma fuente que la sección visible. */
export function buildFaqPageNode(faqs: FaqItem[]): JsonLdNode {
  return {
    '@type': 'FAQPage',
    '@id': `${site.url}/#faq`,
    mainEntity: faqs.map((faq) => ({
      '@type': 'Question',
      name: faq.question,
      acceptedAnswer: {
        '@type': 'Answer',
        text: faq.answer,
      },
    })),
  };
}

/** Grafo completo que se serializa en el <head> del sitio. */
export function buildStructuredData(faqs: FaqItem[] = []) {
  const graph: JsonLdNode[] = [buildStoreNode(), buildWebsiteNode()];
  if (faqs.length > 0) graph.push(buildFaqPageNode(faqs));

  return {
    '@context': 'https://schema.org',
    '@graph': graph,
  };
}
