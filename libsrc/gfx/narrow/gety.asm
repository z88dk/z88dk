
        INCLUDE "graphics/grafix.inc"
        SECTION code_graphics

        PUBLIC  gety
        PUBLIC  _gety

        EXTERN  __gfx_coords

;
;    $Id: gety.asm $
;

; ******************************************************************
;
; Get the current X coordinate of the graphics cursor.
;
;

gety:
_gety:

        ld      hl, (__gfx_coords)
        ld      h, 0
        ret
