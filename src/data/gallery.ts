import type { ImageMetadata } from 'astro';
import type { WhatsAppContext } from './site';

/**
 * Imágenes del sitio, centralizadas en src/assets/images.
 *
 * Reemplazo de material provisorio por fotografías reales autorizadas:
 * 1. Guardar la fotografía en src/assets/images con el MISMO nombre de archivo
 *    (por ejemplo hero.jpg) y el mismo encuadre vertical u horizontal.
 * 2. Actualizar el texto alternativo de cada slot en este archivo.
 * 3. Correr `npm run build`.
 *
 * Las imágenes provisorias se regeneran con `npm run placeholders`.
 */
const modules = import.meta.glob<{ default: ImageMetadata }>('../assets/images/*.jpg', {
  eager: true,
});

function image(file: string): ImageMetadata {
  const module = modules[`../assets/images/${file}.jpg`];
  if (!module) {
    throw new Error(`Imagen no encontrada: ${file}.jpg en src/assets/images.`);
  }
  return module.default;
}

export interface GalleryItem {
  src: ImageMetadata;
  alt: string;
  /** Columnas que ocupa en la grilla editorial de escritorio. */
  span: string;
  /** Proporción reservada para evitar saltos de layout (CLS). */
  ratio: string;
  /** Desplazamiento vertical opcional para la composición escalonada. */
  offset?: string;
}

export interface GalleryChapter {
  id: string;
  index: string;
  title: string;
  description: string;
  whatsapp: WhatsAppContext;
  items: GalleryItem[];
}

export const heroImage: ImageMetadata = image('hero');
export const experienceImage: ImageMetadata = image('experience');
export const storyImage: ImageMetadata = image('story');

export const categoryImages = {
  novias: image('category-novias'),
  fiesta: image('category-fiesta'),
  celebraciones: image('category-celebraciones'),
} as const;

export const galleryChapters: GalleryChapter[] = [
  {
    id: 'galeria-novias',
    index: '01',
    title: 'Novias',
    description:
      'Vestidos de novia elegidos con calma, con asesoramiento en cada paso de la elección.',
    whatsapp: 'novias',
    items: [
      {
        src: image('gallery-novias-01'),
        alt: 'Vestido de novia de caída fluida en tono marfil (imagen provisoria).',
        span: 'md:col-span-5',
        ratio: 'aspect-[3/4]',
      },
      {
        src: image('gallery-novias-02'),
        alt: 'Detalle de espalda de un vestido de novia (imagen provisoria).',
        span: 'md:col-span-7',
        ratio: 'aspect-[4/3]',
        offset: 'md:mt-16',
      },
      {
        src: image('gallery-novias-03'),
        alt: 'Vestido de novia de silueta columna en tono champagne (imagen provisoria).',
        span: 'md:col-span-4',
        ratio: 'aspect-[4/5]',
      },
      {
        src: image('gallery-novias-04'),
        alt: 'Novia con velo largo en una galería de estilo clásico (imagen provisoria).',
        span: 'md:col-span-8',
        ratio: 'aspect-[16/11]',
      },
    ],
  },
  {
    id: 'galeria-fiesta',
    index: '02',
    title: 'Fiesta y casamiento',
    description:
      'Piezas para invitadas, casamientos y fiestas, pensadas según la ocasión y el estilo de cada persona.',
    whatsapp: 'fiesta',
    items: [
      {
        src: image('gallery-fiesta-01'),
        alt: 'Vestido de fiesta largo en tono arena (imagen provisoria).',
        span: 'md:col-span-7',
        ratio: 'aspect-[4/5]',
      },
      {
        src: image('gallery-fiesta-02'),
        alt: 'Vestido de casamiento en tono champagne con detalles dorados (imagen provisoria).',
        span: 'md:col-span-5',
        ratio: 'aspect-[3/4]',
        offset: 'md:mt-20',
      },
    ],
  },
  {
    id: 'galeria-celebraciones',
    index: '03',
    title: 'Celebraciones',
    description:
      'Vestidos para ocasiones especiales, con la atención de una boutique que escucha tu estilo.',
    whatsapp: 'celebraciones',
    items: [
      {
        src: image('gallery-celebraciones-01'),
        alt: 'Vestido para celebración en tonos cálidos (imagen provisoria).',
        span: 'md:col-span-5',
        ratio: 'aspect-[4/5]',
      },
      {
        src: image('gallery-celebraciones-02'),
        alt: 'Detalle de textura de un vestido de celebración (imagen provisoria).',
        span: 'md:col-span-7',
        ratio: 'aspect-[16/10]',
        offset: 'md:mt-12',
      },
    ],
  },
];
