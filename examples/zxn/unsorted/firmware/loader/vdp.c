/*
TBBlue / ZX Spectrum Next project

Copyright (c) 2015 Fabio Belavenuto & Victor Trucco

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <arch/zxn.h>
#include "vdp.h"

// FONT

#define font font_8x8_zx_system
extern unsigned char font_8x8_zx_system[];   // from z88dk library

// VARIABLES

unsigned char cx, cy;

// FUNCTIONS

void vdp_gotoxy(unsigned char x, unsigned char y)
{
   cx = x & 31;
   cy = y;
   if (cy > 23) cy = 23;
}

void vdp_putchar(unsigned char c)
{
   unsigned char *src;
   unsigned char *dst;
   
   src = &font[(c-32)*8];
   dst = zx_cxy2saddr(cx,cy);

   for (unsigned char i = 0; i != 8; ++i)
   {
      *dst = *src++;
      dst += 0x100;
   }

   ++cx;
}

void vdp_prints(const char *str)
{
   while (*str) vdp_putchar(*str++);
}
