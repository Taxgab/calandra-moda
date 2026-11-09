// @ts-check
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'astro/config';

// Sitio 100% estático (SSG). El dominio provisorio también vive en src/data/site.ts.
export default defineConfig({
  site: 'https://www.calandramoda.com.ar',
  trailingSlash: 'ignore',
  // La compresión HTML-aware preserva espacios significativos entre elementos inline.
  compressHTML: true,
  integrations: [sitemap()],
  vite: {
    plugins: [tailwindcss()],
  },
  build: {
    inlineStylesheets: 'auto',
  },
});
