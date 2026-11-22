    INCLUDE "classic/gfx/grafix.inc"
    SECTION code_graphics
    PUBLIC  setxy

    EXTERN  __gfx_coords

;
;    $Id: setxy.asm,v 1.7 2016-07-02 09:01:35 dom Exp $
;

; ******************************************************************
;
; Move current pixel coordinate to (x0,y0). Only legal coordinates
; are accepted.
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; X-range is always legal (0-255). Y-range must be 0 - 63.
;
; in:  hl    = (x,y) coordinate
;
; registers changed    after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
setxy:
IF  _GFX_MAXX<>256
    ld      a, h
    cp      _GFX_MAXX
    ret     nc
ENDIF
IF  _GFX_MAXY<>256
    ld      a, l
    cp      _GFX_MAXY
    ret     nc                          ; out of range...
ENDIF
    ld      (__gfx_coords), hl
    ret
