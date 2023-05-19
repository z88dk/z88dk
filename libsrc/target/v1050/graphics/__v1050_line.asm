
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __v1050_line

	EXTERN     l_cmp

	EXTERN    __gfx_coords

	EXTERN    v1050_sendchar
	EXTERN    v1050_sendchar_fast
	EXTERN    __v1050_pixel
	EXTERN    __v1050_coord

;
;       $Id: __v1050_line.asm $
;

; ******************************************************************
;
; ----- draw(int x, int y, int x2, int y2)
; de = x1, hl = y1, hl'=x2, de'=y2
;


__v1050_line:

		call __v1050_pixel
		
		exx
        ld      (__gfx_coords),hl      ; store X
        ld      (__gfx_coords+2),de    ; store Y: COORDS must be 2 bytes wider
		
		push hl

		; Draw a line from cursor to (X,Y); ESC ? x ; y L

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
		
		ld l,'L'
		jp v1050_sendchar
