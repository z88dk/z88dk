
    INCLUDE    "graphics/grafix.inc"
      SECTION code_graphics
    
    PUBLIC    getx
    PUBLIC    _getx

    EXTERN    __gfx_coords

;
;    $Id: getx.asm $
;

; ******************************************************************
;
; Get the current X coordinate of the graphics cursor.
;
;

.getx
._getx

    ld    hl,(__gfx_coords)
    ld    l,h
    ld    h,0
    ret
