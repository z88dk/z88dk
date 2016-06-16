;--------------------------------------------------------------------------
;  mulchar.s
;
;  Copyright (C) 2000, Michael Hope
;
;  This library is free software; you can redistribute it and/or modify it
;  under the terms of the GNU General Public License as published by the
;  Free Software Foundation; either version 2.1, or (at your option) any
;  later version.
;
;  This library is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License 
;  along with this library; see the file COPYING. If not, write to the
;  Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
;   MA 02110-1301, USA.
;
;  As a special exception, if you link this library with other files,
;  some of which are compiled with SDCC, to produce an executable,
;  this library does not by itself cause the resulting executable to
;  be covered by the GNU General Public License. This exception does
;  not however invalidate any other reasons why the executable file
;   might be covered by the GNU General Public License.
;--------------------------------------------------------------------------

        SECTION code_l_sdcc
	PUBLIC __mulint_rrx_s
	PUBLIC __muluchar_rrx_hds
	PUBLIC __mulint_rrx_hds
	PUBLIC __mul16

__mulint_rrx_s:
        pop     af
        pop     hl
        pop     de
        push    de
        push    hl
        push    af

        ;; Fall through

__muluchar_rrx_hds:
__mulint_rrx_hds:
	;; Parameters:
	;;	hl, de (left, right irrelevant)
	ld	b,h
	ld	c,l

	;; 16-bit multiplication
	;;
	;; Entry conditions
	;; bc = multiplicand
	;; de = multiplier
	;;
	;; Exit conditions
	;; hl = less significant word of product
	;;
	;; Register used: AF,BC,DE,HL
__mul16:
	xor	a,a
	ld	l,a
	or	a,b
	ld	b,#16

        ;; Optimise for the case when this side has 8 bits of data or
        ;; less.  This is often the case with support address calls.
        jr      NZ,lab2
        ld      b,#8
        ld      a,c
.lab1
        ;; Taken from z88dk, which originally borrowed from the
        ;; Spectrum rom.
        add     hl,hl
.lab2
        rl      c
        rla                     ;DLE 27/11/98
        jr      NC,lab3
        add     hl,de
.lab3
        djnz    lab1
        ret

