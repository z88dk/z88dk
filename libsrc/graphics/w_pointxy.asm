	INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	w_pointxy
	EXTERN		l_cmp


	EXTERN	w_pixeladdress

;
;	$Id: w_pointxy.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;

; ******************************************************************
;
; Check if pixel at (x,y) coordinate is set or not.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; (0,0) origin is defined as the top left corner.
;
;  in:	hl,de =	(x,y) coordinate of pixel to test
; out:	Fz = 0, if pixel is set, otherwise Fz = 1.
;
; registers changed after return:
;  ..bcdehl/ixiy same
;  af....../.... different
;
.w_pointxy
                        push    hl
                        ld      hl,maxy
                        call    l_cmp
                        pop     hl
                        ret     nc               ; Return if Y overflows

                        push    de
                        ld      de,maxx
                        call    l_cmp
                        pop     de
                        ret     c               ; Return if X overflows
                        
                        call    w_pixeladdress
                        ld      b,a
                        ld      a,1
                        jr      z, test_pixel     ; pixel is at bit 0...
.pix_position           rlca
                        djnz    pix_position
.test_pixel             ex      de,hl
                        and     (hl)
                        ret
