        INCLUDE "graphics/grafix.inc"

        SECTION code_clib
        PUBLIC    w_respixel

        EXTERN     l_cmp

        EXTERN    __gfx_coords
        EXTERN    px8_conout

;
;       $Id: w_respixl.asm, Stefano - 2017 $
;

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
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
.w_respixel
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
                        
                        ld      (__gfx_coords),hl     ; store X
                        ld      (__gfx_coords+2),de   ; store Y: COORDS must be 2 bytes wider
                        push	hl
						push	de
						
						ld	c,27		; ESCape
						call px8_conout
						
						ld	c,0xc7		; PSET/PRESET
						call px8_conout
						ld	c,0		; PRESET
						call px8_conout
						pop de
						ld c,e
						call px8_conout	; y
						pop hl
						push hl
						ld c,h
						call px8_conout	; x (msb)
						pop hl
						ld c,l
						jp px8_conout	; x (lsb)

