        INCLUDE "graphics/grafix.inc"
        SECTION code_graphics
        PUBLIC  w_setxy
        EXTERN  l_graphics_cmp

        EXTERN  __gfx_coords

;
;    $Id: w_setxy.asm $
;

; ******************************************************************
;
; Move current pixel coordinate to (x0,y0). Only legal coordinates
; are accepted.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; X-range is always legal (0-255). Y-range must be 0 - 63.
;
; in:  hl,de = (x,y) coordinate
;
; registers changed    after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
w_setxy:

        push    hl
        ld      hl, maxy
        call    l_graphics_cmp
        pop     hl
        ret     nc                      ; Return if Y overflows

        push    de
        ld      de, maxx
        call    l_graphics_cmp
        pop     de
        ret     c                       ; Return if X overflows

        ld      (__gfx_coords), hl      ; store X
  IF    __CPU_INTEL__
        ex      de, hl
        ld      (__gfx_coords+2), hl
        ex      de, hl
  ELSE
        ld      (__gfx_coords+2), de    ; store Y: COORDS must be 2 bytes wider
  ENDIF

        ret
