;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: closegfx.asm,v 1.7 2016-03-08 23:09:57 dom Exp $
;


;Usage: closegfx(struct *window)
;
;Close the map screen and restore memory map to normal


                INCLUDE "graphics/grafix.inc"    ; Contains fn defs
                INCLUDE "map.def"

		SECTION	code_clib

                PUBLIC    closegfx
                PUBLIC    _closegfx




.closegfx
._closegfx
		push	ix
                pop     bc
                pop     ix      ;y
                push    ix
                push    bc
                ld      a,(ix+windnum)
                ld      bc,mp_del
                call_oz(os_map)
                ld      hl,0            ;NULL=success
		pop	ix
                ret

