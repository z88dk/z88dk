;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: closegfx.asm,v 1.1 2016-04-03 20:04:32 dom Exp $
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
                pop     bc
                pop     hl      ;window
                push    hl 
                push    bc

		push	ix
                ld      a,(hl)		;window number
                ld      bc,mp_del
                call_oz(os_map)
                ld      hl,0            ;NULL=success
		pop	ix
                ret

