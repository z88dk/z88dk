        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_xorpixel

        EXTERN     w_respixel

;
;       $Id: w_xorpixl.asm $
;

; ******************************************************************
;
; Xor pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_xorpixel
					jp w_respixel
