/*-------------------------------------------------------------------------
   calloc.c - allocate memory.

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
#include <string.h>
#include <stdint.h>
#include "farmalloc.h"

void *__far calloc_far (size_t nmemb, size_t size)
{
	void * __far ptr;

	unsigned long msize = (unsigned long)nmemb * (unsigned long)size;

	_Static_assert(sizeof(unsigned long) >= sizeof(size_t) * 2,
		"size_t too large wrt. unsigned long for overflow check");

	if (msize > SIZE_MAX)
		return(0);

	if (ptr = malloc_far((size_t)msize))
		memsetf(ptr, 0, (size_t)msize);

	return(ptr);
}

