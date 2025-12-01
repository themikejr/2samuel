import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
	// Load Markdown and MDX files in the `src/content/blog/` directory.
	loader: glob({ base: './src/content/blog', pattern: '**/*.{md,mdx}' }),
	// Type-check frontmatter using a schema
	schema: ({ image }) =>
		z.object({
			title: z.string(),
			description: z.string(),
			// Transform string to Date object
			pubDate: z.coerce.date(),
			updatedDate: z.coerce.date().optional(),
			heroImage: image().optional(),
		}),
});

const characters = defineCollection({
	// Load JSON files in the `src/content/characters/` directory.
	loader: glob({ base: './src/content/characters', pattern: '**/*.json' }),
	// Type-check using a schema based on ACAI data structure
	schema: z.object({
		// ACAI identifier
		acaiId: z.string(),
		// Display name
		name: z.string(),
		// Character description
		description: z.string(),
		// Gender
		gender: z.enum(['male', 'female']).optional(),
		// Familial relationships (ACAI person IDs)
		father: z.string().optional(),
		mother: z.string().optional(),
		partners: z.array(z.string()).optional(),
		offspring: z.array(z.string()).optional(),
		// Tribal/national affiliation (ACAI group ID)
		tribe: z.string().optional(),
		// Roles this person held
		roles: z.array(z.string()).optional(),
		// Scripture references where this person appears in 2 Samuel
		references: z.array(z.string()),
	}),
});

export const collections = { blog, characters };
