// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';
import remarkFootnotes from 'remark-footnotes';
import remarkTufteSidenotes from './src/plugins/remark-tufte-sidenotes.js';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://example.com',
  integrations: [mdx(), sitemap()],
  markdown: {
    remarkPlugins: [remarkFootnotes, remarkTufteSidenotes],
  },

  vite: {
    plugins: [tailwindcss()],
  },
});