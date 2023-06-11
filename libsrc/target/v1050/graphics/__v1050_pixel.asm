
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __v1050_pixel

	EXTERN     l_cmp

	EXTERN    __gfx_coords
	EXTERN    v1050_sendchar
	EXTERN    v1050_sendchar_fast
	EXTERN    __v1050_coord

;
;       $Id: __v1050_pixel.asm $
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

__v1050_pixel:

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

		;Set drawing mode: ESC ? m ; t T
		ld l,27
		call v1050_sendchar
		ld l,'?'
		call v1050_sendchar_fast
		ld a,'8'
		cp c
		jr nz,noxor
		; XOR mode requires "128", in this case we expect "8",
		; otherwise "0" for PLOT, or "1" UNPLOT
		ld l,'1'
		call v1050_sendchar
		ld l,'2'
		call v1050_sendchar
noxor:
		ld l,c
		call v1050_sendchar
		ld l,';'
		call v1050_sendchar

		; Force drawing type to "solid", thus "255".
		;ld l,'2'
		;call v1050_sendchar
		;ld l,'5'
		;call v1050_sendchar
		;ld l,'5'
		;call v1050_sendchar
		ld l,'='
		call v1050_sendchar
		ld l,255
		call v1050_sendchar_fast
		ld l,0
		call v1050_sendchar


		ld l,'T'
		call v1050_sendchar
		
		;Draw a point at (X,Y); ESC ? x ; y M

		ld l,27
		call v1050_sendchar
		ld l,'?'
		call v1050_sendchar_fast
		
		; X
		pop hl
		call __v1050_coord


		ld l,';'
		call v1050_sendchar_fast

		; Y
		ex de,hl
		call __v1050_coord
		
		ld l,'M'
		jp v1050_sendchar

