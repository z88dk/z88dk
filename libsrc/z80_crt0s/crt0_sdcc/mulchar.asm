;--------------------------------------------------------------------------
;  mulchar.s
;
;  Copyright (C) 2009, Philipp Klaus Krause
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
	PUBLIC __muluchar_rrx_s
	PUBLIC __mulsuchar_rrx_s
	PUBLIC __muluschar_rrx_s
	PUBLIC __mulschar_rrx_s
	PUBLIC __mulschar_rrx_hds
	EXTERN  __mul16

; This multiplication routine is similar to the one
; from Rodnay Zaks, "Programming the Z80".

; Now replaced by a builtin for code generation, but
; still called from some asm files in this directory.
__muluchar_rrx_s:
        ld      hl, #2+1
        ld      d, h
        add     hl, sp
        ld      e, (hl)
        dec     hl
        ld      h, (hl)
        ld      l, d
        ld      b, #8
muluchar_rrx_s_loop:
        add     hl, hl
        jr      nc, muluchar_rrx_s_noadd
        add     hl, de
muluchar_rrx_s_noadd:
        djnz    muluchar_rrx_s_loop
        ret

; operands have different sign

__mulsuchar_rrx_s:
        ld      hl,#2+1
        ld      b, h
        add     hl,sp

        ld      e,(hl)
        dec     hl
        ld      c,(hl)
        jr      signexte

__muluschar_rrx_s:
        ld      hl,#2
        ld      b, h
        add     hl,sp

        ld      e,(hl)
        inc     hl
        ld      c,(hl)
        jr      signexte

;; Originally from GBDK by Pascal Felber.

__mulschar_rrx_s:
        ld      hl,#2+1
        add     hl,sp

        ld      e,(hl)
        dec     hl
        ld      l,(hl)

        ;; Fall through
__mulschar_rrx_hds:
        ;; Need to sign extend before going in.
        ld      c,l

        ld      a,l
        rla
        sbc     a,a
        ld      b,a
signexte:
        ld      a,e
        rla
        sbc     a,a
        ld      d,a

        jp      __mul16

