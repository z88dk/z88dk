	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib
	PUBLIC    w_plotpixel

	EXTERN   __mbc_pixel

;
;       $Id: w_plotpixl.asm $
;

; ******************************************************************
;
; Plot pixel at (x,y) coordinate.
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

.w_plotpixel

		ld c,'S'
		jp __mbc_pixel

