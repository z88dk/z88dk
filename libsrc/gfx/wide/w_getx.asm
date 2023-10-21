
        INCLUDE "graphics/grafix.inc"
        SECTION code_graphics

        PUBLIC  getx
        PUBLIC  _getx

        EXTERN  __gfx_coords

;
;    $Id: w_getx.asm $
;

; ******************************************************************
;
; Get the current X coordinate of the graphics cursor.
;
;

getx:
_getx:

        ld      hl, (__gfx_coords)
        ret
