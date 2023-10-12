
        INCLUDE "graphics/grafix.inc"
        SECTION code_graphics

        PUBLIC  gety
        PUBLIC  _gety

        EXTERN  __gfx_coords

;
;    $Id: w_gety.asm $
;

; ******************************************************************
;
; Get the current X coordinate of the graphics cursor.
;
;

gety:
_gety:

        ld      hl, (__gfx_coords+2)
        ret
