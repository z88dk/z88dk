        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_respixel

        EXTERN     w_pixel


; ******************************************************************
;
; Reset pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;

.w_respixel
			ld	a,1
			jp	w_pixel
