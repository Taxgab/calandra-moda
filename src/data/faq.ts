export interface FaqItem {
  question: string;
  answer: string;
}

/**
 * Preguntas frecuentes.
 *
 * Son la base de la sección visible y del marcado FAQPage (AEO): el texto
 * mostrado y el estructurado salen de esta misma fuente.
 * Solo se incluyen respuestas verificables con la información confirmada:
 * no hay horarios, teléfonos, precios ni servicios inventados.
 */
export const faqs: FaqItem[] = [
  {
    question: '¿Qué tipo de vestidos ofrece Calandra Moda?',
    answer:
      'Calandra Moda es una boutique de vestidos especializada en vestidos de novia, de fiesta y para casamientos y celebraciones. Cada elección se acompaña con asesoramiento personalizado.',
  },
  {
    question: '¿Calandra Moda vende o alquila vestidos?',
    answer:
      'Calandra Moda vende vestidos. La boutique se dedica a la venta de vestidos de novia, fiesta y celebración.',
  },
  {
    question: '¿Dónde está ubicada la boutique?',
    answer:
      'En Gran Galería Lanús, Av. 9 de Julio 1126, Lanús Este, Buenos Aires.',
  },
  {
    question: '¿Cómo pido asesoramiento para elegir mi vestido?',
    answer:
      'Podés escribirnos por WhatsApp desde cualquiera de los botones de este sitio y contarnos qué estás buscando. También podés acercarte a la boutique, en Lanús Este.',
  },
  {
    question: '¿Atienden novias, fiestas y celebraciones en la misma boutique?',
    answer:
      'Sí. En Calandra Moda se atienden elecciones de vestidos de novia, de fiesta y de casamiento, con el mismo acompañamiento personalizado.',
  },
  {
    question: '¿Qué diferencia a Calandra Moda?',
    answer:
      'La atención personalizada y el asesoramiento durante toda la elección, sostenidos por más de 20 años de experiencia en Lanús.',
  },
];
