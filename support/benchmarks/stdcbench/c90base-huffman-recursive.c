/* This part of the benchmark is based on real-world code.
   Source: http://www.colecovision.eu/

   (c) 2005 - 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#include "c90base-huffman.h"

#ifdef C90BASE

#if __STDC_VERSION__ >= 199901L
#include <stdbool.h>
#else
typedef unsigned char bool;
#endif

unsigned char cvu_get_huffman_recursive(struct cvu_huffman_state *state)
{
	bool direction;
	unsigned char ret;

	state->buffer >>= 1;
	if(state->bit == 8)
	{
		state->buffer = (state->input)();
		state->bit = 0;
	}
	direction = state->buffer & 0x01;
	state->bit++;

	if(!direction)	/* Left */
	{
		if(state->current >= state->ls && state->current < state->rs)
		{
			ret = state->nodes[state->current].left;
			state->current = state->root;
		}
		else
		{
			state->current = state->nodes[state->current].left;
			ret = cvu_get_huffman_recursive(state);
		}
	}
	else	/* Right */
	{
		if(state->current >= state->bs)
		{
			ret = state->nodes[state->current].right;
			state->current = state->root;
		}
		else
		{
			state->current = state->nodes[state->current].right;
			ret = cvu_get_huffman_recursive(state);
		}
	}

	return(ret);
}

#endif

