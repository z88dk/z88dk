;--------------------------------------------------------------------------
;  modunsigned.s
;
;  Copyright (C) 2009-2010, Philipp Klaus Krause
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
	PUBLIC __moduchar_rrx_s
	PUBLIC __moduchar_rrx_hds
	PUBLIC __moduint_rrx_s
	EXTERN __divunsigned
        EXTERN __divu8
        EXTERN  __divu16
	PUBLIC __moduint_rrx_hds


__moduchar_rrx_s:
        ld      hl,#2+1
        add     hl,sp

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ;; Fall through
__moduchar_rrx_hds:
        call    __divu8

	ex	de,hl

        ret

__moduint_rrx_s:
        pop     af
        pop     hl
        pop     de
        push    de
        push    hl
        push    af

        ;; Fall through
__moduint_rrx_hds:
        call    __divu16

        ex      de,hl

        ret

