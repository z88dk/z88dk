
	INCLUDE "graphics/grafix.inc"

	SECTION	  code_clib

	PUBLIC    __mbc_line

	EXTERN     l_cmp

	EXTERN    __gfx_coords
	EXTERN    mbc_sendchar

;
;       $Id: __mbc_line.asm $
;

; ******************************************************************
;
; ----- draw(int x, int y, int x2, int y2)
; de = x1, hl = y1, hl'=x2, de'=y2
;


__mbc_line:

		push hl
		ld h,c
		
		ld l,27
		call mbc_sendchar
		ld l,'P'
		call mbc_sendchar
		ld l,c			; "0" (draw) or "1" (undraw)
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
		call mbc_sendchar
		
		exx
        ld      (__gfx_coords),hl      ; store X
        ld      (__gfx_coords+2),de    ; store Y: COORDS must be 2 bytes wider
		push hl

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

