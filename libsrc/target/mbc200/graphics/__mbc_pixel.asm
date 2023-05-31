
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __mbc_pixel

	EXTERN     l_cmp

	EXTERN    __gfx_coords
	EXTERN    mbc_sendchar

;
;       $Id: __mbc_pixel.asm $
;

; ******************************************************************
;
; Plot/unplot pixel at (x,y) coordinate, "S" or "R" operation in register C 
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

__mbc_pixel:

        push    hl
        ld      hl,maxy
        call    l_cmp
        pop     hl
        ret     nc               ; Return if Y overflows

        push    de
        ld      de,maxx
        call    l_cmp
        pop     de
        ret     c                ; Return if X overflows
        
        ld      (__gfx_coords),hl      ; store X
        ld      (__gfx_coords+2),de    ; store Y: COORDS must be 2 bytes wider
		
		push hl
		
		ld l,27
		call mbc_sendchar
		ld l,c			; "R"eset or "S"et
		call mbc_sendchar

		; Y
		ld l,d
		call mbc_sendchar
		ld l,e
		call mbc_sendchar

		pop de
		; X
		ld l,d
		call mbc_sendchar
		ld l,e
		jp mbc_sendchar
