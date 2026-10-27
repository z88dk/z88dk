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

unsigned char cvu_get_huffman_iterative(struct cvu_huffman_state *state)
{
	unsigned char current;
	unsigned char ret;

	current = state->root;

	for(;;)
	{
		state->buffer >>= 1;
		if(state->bit == 8)
		{
			state->buffer = (state->input)();
			state->bit = 0;
		}
		state->bit++;

		if(!(state->buffer & 0x01))	/* Left */
		{
			if(current >= state->ls && current < state->rs)
			{
				ret = state->nodes[current].left;
				break;
			}

			current = state->nodes[current].left;
		}
		else	/* Right */
		{
			if(current >= state->bs)
			{
				ret = state->nodes[current].right;
				break;
			}

			current = state->nodes[current].right;
		}
	}
	
	return(ret);
}

#endif

