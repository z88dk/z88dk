/*-------------------------------------------------------------------------
   malloc.c - allocate memory.

   Copyright (C) 2015, Philipp Klaus Krause, pkk@spth.de

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
#include <stdio.h>
#include <stddef.h>

#include "farmalloc.h"


void *__far malloc_far(size_t size)
{
	header_t *__far h;
	header_t *__far * __far f;

	if(!size || size + offsetof(struct header, next_free) < size)
		return(0);
	size += offsetof(struct header, next_free);
	if(size < sizeof(struct header)) // Requiring a minimum size makes it easier to implement free(), and avoid memory leaks.
		size = sizeof(struct header);

    
	for(h = __far_heap, f = &__far_heap; h; f = &(h->next_free), h = h->next_free)
	{
		size_t blocksize = (char * __far)(h->next) - (char *__far)h;

      //  printf("h = %lX Blocksize is %u we want %u\n",h,blocksize,size);
		if(blocksize >= size) // Found free block of sufficient size.
		{
			if(blocksize >= size + sizeof(struct header)) // It is worth creating a new free block
			{
				header_t * __far newheader = (header_t * __far )((uint32_t)h + (uint32_t)size);
				newheader->next = h->next;
				newheader->next_free = h->next_free;
				*f = newheader;
				h->next = newheader;
			}
			else
				*f = h->next_free;
			return(&(h->next_free));
		}
	}
        

	return(0);
}

