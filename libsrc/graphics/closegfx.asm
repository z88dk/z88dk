;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: closegfx.asm,v 1.6 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: closegfx(struct *window)
;
;Close the map screen and restore memory map to normal


                INCLUDE "graphics/grafix.inc"    ; Contains fn defs
                INCLUDE "map.def"

                PUBLIC    closegfx

 ;               XREF    oldozbank



.closegfx
                pop     bc
                pop     ix      ;y
                push    ix
                push    bc
;Restore old bindings
;                ld      a,(oldozbank)
;                ld      (map_bk),a
;                out     (map_bk-$400),a
                ld      a,(ix+windnum)
                ld      bc,mp_del
                call_oz(os_map)
                ld      hl,0            ;NULL=success
                ret

