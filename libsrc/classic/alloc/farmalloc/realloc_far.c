/*-------------------------------------------------------------------------
   realloc.c - allocate memory.
   
   Always behaves according to C90 (i.e. does not take advantage of
   undefined behaviour introduced in C2X or implementation-defined
   behaviour introduced in C17.

   Copyright (C) 2015-2020, Philipp Klaus Krause, pkk@spth.de

   This library is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License 
   along with this library; see the file COPYING. If not, write to the
   Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.

   As a special exception, if you link this library with other files,
   some of which are compiled with SDCC, to produce an executable,
   this library does not by itself cause the resulting executable to
   be covered by the GNU General Public License. This exception does
   not however invalidate any other reasons why the executable file
   might be covered by the GNU General Public License.
-------------------------------------------------------------------------*/

#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>

#include "farmalloc.h"

#if 1
// Just replaces the block.
void *__far realloc_far(void * __far ptr, size_t size)
{
    header_t * __far h;
    size_t oldblocksize;
    void *__far ret;

    if(ptr == NULL)
        return(malloc_far(size));

	if(size == 0) {
		free_far(ptr);
		return(0);
	}

	h = (void * __far)((char * __far)ptr - offsetof(struct header, next_free));
	oldblocksize = (char * __far)(h->next) - (char * __far)h - offsetof(struct header, next_free);

    ret = malloc_far(size);
    memcpyf(ret, ptr, size < oldblocksize ? size : oldblocksize);
    free_far(ptr);
    return ret;
}
#else

// Heap is corrupted with this, either a bug here or in pointer handling...
void *__far realloc_far(void * __far ptr, size_t size)
{
	void *__far ret;
	header_t * __far h, * __far next_free, * __far prev_free;
	header_t *__far * __far f, *__far * __far pf;
	size_t blocksize, oldblocksize, maxblocksize;

	if(ptr == NULL)
		return(malloc_far(size));

	if(size == 0) {
		free_far(ptr);
		return(0);
	}

	prev_free = 0, pf = 0;
	for(h = __far_heap, f = &__far_heap; h && h < ptr; prev_free = h, pf = f, f = &(h->next_free), h = h->next_free); // Find adjacent blocks in free list
	next_free = h;
    printf("Next free block is %lX\n",next_free);

	if(size + offsetof(struct header, next_free) < size) // Handle overflow
		return(0);
	blocksize = size + offsetof(struct header, next_free);
	if(blocksize < sizeof(struct header)) // Requiring a minimum size makes it easier to implement free(), and avoid memory leaks.
		blocksize = sizeof(struct header);

	h = (void * __far)((char * __far)ptr - offsetof(struct header, next_free));
	oldblocksize = (char * __far)(h->next) - (char * __far)h;

    printf("Old block size %u\n",oldblocksize);

	maxblocksize = oldblocksize;
	if(prev_free && prev_free->next == h) // Can merge with previous block
		maxblocksize += (char * __far)h - (char * __far)prev_free;
	if(next_free == h->next) // Can merge with next block
		maxblocksize += (char * __far)(next_free->next) - (char * __far)next_free;

    printf("Block size %u max=%u\n",blocksize,maxblocksize);
	if(blocksize <= maxblocksize) // Can resize in place.
	{
		if(prev_free && prev_free->next == h) // Always move into previous block to defragment
		{
			//memmove_far(prev_free, h, blocksize <= oldblocksize ? blocksize : oldblocksize);
			memcpyf(prev_free, h, blocksize <= oldblocksize ? blocksize : oldblocksize);
			h = prev_free;
			*pf = next_free;
			f = pf;
		}

		if(next_free && next_free == h->next) // Merge with following block
		{
			h->next = next_free->next;
			*f = next_free->next_free;
		}

		if(maxblocksize >= blocksize + sizeof(struct header)) // Create new block from free space
		{
			header_t * __far newheader = (header_t * __far)((char * __far)h + blocksize);
			newheader->next = h->next;
			newheader->next_free = *f;
			*f = newheader;
			h->next = newheader;
		}

		return(&(h->next_free));
	}

	if(ret = malloc_far(size))
	{
		size_t oldsize = oldblocksize - offsetof(struct header, next_free);
		memcpyf(ret, ptr, size <= oldsize ? size : oldsize);
		free_far(ptr);
		return(ret);
	}

	return(0);
}
#endif

