;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...

;
;	$Id: swapgfxbk.asm,v 1.8 2017-01-02 22:57:59 aralbrec Exp $
;

		SECTION   code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

                EXTERN    gfx_bank
		EXTERN	  z88_map_bank

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1


		INCLUDE	"graphics/grafix.inc"

.swapgfxbk
._swapgfxbk
.swapgfxbk1
._swapgfxbk1
                push    hl
                push    de
                ld      hl,z88_map_bank       ;$4Dx
                ld      e,(hl)
                ld      a,(gfx_bank)    ;in crt0
                ld      (hl),a
                out     (z88_map_bank-$400),a
                ld      a,e
                ld      (gfx_bank),a
                pop     de
                pop     hl
                ret






