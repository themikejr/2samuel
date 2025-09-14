import { visit } from 'unist-util-visit';

// Custom remark plugin to convert footnotes to Tufte-style sidenotes
export default function remarkTufteSidenotes() {
  return (tree) => {
    const footnotes = new Map();
    
    // First pass: collect all footnote definitions
    visit(tree, 'footnoteDefinition', (node) => {
      footnotes.set(node.identifier, node.children);
    });
    
    // Second pass: replace footnote references with Tufte sidenote structure
    visit(tree, 'footnoteReference', (node, index, parent) => {
      const footnoteContent = footnotes.get(node.identifier);
      if (!footnoteContent) return;
      
      const uniqueId = `sn-${node.identifier}`;
      
      // Create Tufte-style sidenote HTML structure
      const tufteStructure = {
        type: 'html',
        value: `<label for="${uniqueId}" class="margin-toggle sidenote-number"></label><input type="checkbox" id="${uniqueId}" class="margin-toggle"/><span class="sidenote">${renderContent(footnoteContent)}</span>`
      };
      
      // Replace the footnote reference with the Tufte structure
      parent.children[index] = tufteStructure;
    });
    
    // Third pass: remove the footnoteDefinition nodes since we've inlined them
    visit(tree, 'footnoteDefinition', (node, index, parent) => {
      parent.children.splice(index, 1);
      return [visit.SKIP, index];
    });
  };
}

// Helper function to render footnote content as HTML string
function renderContent(content) {
  return content.map(node => {
    if (node.type === 'paragraph') {
      return node.children.map(child => {
        if (child.type === 'text') {
          return child.value;
        } else if (child.type === 'emphasis') {
          return `<em>${child.children.map(c => c.value).join('')}</em>`;
        } else if (child.type === 'strong') {
          return `<strong>${child.children.map(c => c.value).join('')}</strong>`;
        } else if (child.type === 'link') {
          return `<a href="${child.url}">${child.children.map(c => c.value).join('')}</a>`;
        }
        return child.value || '';
      }).join('');
    } else if (node.type === 'text') {
      return node.value;
    }
    return '';
  }).join(' ');
}