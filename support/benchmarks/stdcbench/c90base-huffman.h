struct cvu_huffman_node
{
        unsigned char left;   /* Position of left node in tree or character. */
        unsigned char right;  /* Position of right node in tree or character. */
};

struct cvu_huffman_state
{
	unsigned char (*input)(void);
	const struct cvu_huffman_node *nodes;	/* Array of nodes */
	unsigned char root;	/* Position of root node among nodes */
	unsigned char ls, bs, rs;
	unsigned char bit;	/* Position of currently processed bit */
	unsigned char buffer;	/* Currently processed input byte */
	unsigned char current;	/* Currently processed node for recursive algorithm */
};

unsigned char cvu_get_huffman_iterative(struct cvu_huffman_state *state);
unsigned char cvu_get_huffman_recursive(struct cvu_huffman_state *state);

