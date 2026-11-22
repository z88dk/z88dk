/* Benchmark compression. The benchmarked algorithm is a combination of RLE and Huffman.
   At a lower level, we mostly benchmark control-flow constructs (including function pointers) and bitwise operations.
   This part of the benchmark is based on real-world code.
   Source: http://www.colecovision.eu/

   (c) 2005 - 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90BASE

#include "c90base-huffman.h"

#if __STDC_VERSION__ < 199901L
#define restrict
#endif

extern const unsigned char c90base_data[];

#define RLE_ESCAPE (const unsigned char)(253)

extern const unsigned char HUFFMAN_ROOT;
extern const unsigned char HUFFMAN_LS, HUFFMAN_BS, HUFFMAN_RS;
extern const struct cvu_huffman_node huffman_tree[255];

void cvu_init_huffman(struct cvu_huffman_state *restrict state, unsigned char(* input)(void), const struct cvu_huffman_node *restrict tree, unsigned char root, unsigned char ls, unsigned char bs, unsigned char rs)
{
	state->input = input;
	state->nodes = tree;
	state->root = root;
	state->ls = ls;
	state->bs = bs;
	state->rs = rs;
	state->bit = 8;
	state->current = state->root;
}

struct cvu_rle_state
{
	unsigned char (*input)(void);
	unsigned char escape;
	unsigned char left;
	unsigned char buffer;
};

struct cvu_compression_state *common_state;

static void cvu_init_rle(struct cvu_rle_state *state, unsigned char (* input)(void), unsigned char escape)
{
	state->input = input;
	state->escape = escape;
	state->left = 0;
}

static unsigned char cvu_get_rle(struct cvu_rle_state *state)
{
	unsigned char next;

	if(state->left)
		goto output;

	next = (state->input)();

	if(next != state->escape)
		return(next);

	state->left = (state->input)();
	state->buffer = (state->input)();

output:
	state->left--;
	return(state->buffer);
}

struct cvu_compression_state
{
	struct cvu_huffman_state huffman;
	struct cvu_rle_state rle;
	const volatile unsigned char *data;
};

static void *cvu_memcpy_compression(void *restrict dest, struct cvu_compression_state *restrict state, unsigned short int n)
{
	unsigned short int i = 0;
	common_state = state;
	for(; n > 0; n--)
		((unsigned char *)(dest))[i++] = cvu_get_rle(&common_state->rle);

	return(dest);
}

static unsigned char read_from_array(void)
{
	return(*((common_state->data)++));
}

static unsigned char read_from_huffman_iterative(void)
{
	return(cvu_get_huffman_iterative(&common_state->huffman));
}

static unsigned char read_from_huffman_recursive(void)
{
	return(cvu_get_huffman_recursive(&common_state->huffman));
}

void c90base_compression(void)
{
	struct cvu_compression_state state;
	unsigned int i, j;

	for(j = 0; j < 4; j++)
	{
		state.data = c90base_data;
		cvu_init_huffman(&state.huffman, &read_from_array, huffman_tree, HUFFMAN_ROOT, HUFFMAN_LS, HUFFMAN_BS, HUFFMAN_RS);
		cvu_init_rle(&state.rle, &read_from_huffman_iterative, RLE_ESCAPE);
		cvu_memcpy_compression(stdcbench_buffer.unsigned_char + 0, &state, 768);

		state.data = c90base_data;
		cvu_init_huffman(&state.huffman, &read_from_array, huffman_tree, HUFFMAN_ROOT, HUFFMAN_LS, HUFFMAN_BS, HUFFMAN_RS);
		cvu_init_rle(&state.rle, &read_from_huffman_recursive, RLE_ESCAPE);
		cvu_memcpy_compression(stdcbench_buffer.unsigned_char + 768, &state, 768);

		for(i = 0; i < 768; i++)
		{
			if (stdcbench_buffer.unsigned_char[i] != stdcbench_buffer.unsigned_char[i + 768])
			{
				stdcbench_error("c90base c90base_compression(): Result validation failed");
				return;
			}
		}
	}
}

#endif

