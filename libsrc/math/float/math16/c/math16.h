/*-------------------------------------------------------------------------
   math16.h: half precision floating point math function declarations

   Copyright (C) 2001, Jesus Calvino-Fraga, jesusc@ieee.org

   This library is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
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

/* Version 1.0 - Initial release */

#ifndef _INC_MATH16_C
#define _INC_MATH16_C

#include <stdint.h>
#include <math.h>

union float16_int
{
    half_t f;
    uint16_t l;
};

/* Top 8 bits of the packed half (sign + exp[4:0] + mant[9:8]).
 * Shift the int, not a memory index, so LE and BE match.
 * After abs: 0x58 => |x| >= 128 (128 = 0x5800). Inf/NaN hi >= 0x7c.
 * >> 8 not a 5-bit field extract (shift cost on sccz80/SDCC). */
#define m16_ieee_hi(u)  ((uint8_t)((uint16_t)(u).l >> 8))

#endif  /* _INC_MATH16_C */

