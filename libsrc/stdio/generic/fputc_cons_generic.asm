;
; Generic console writer
;
; Supports:
;
;  8 = backspace (+erase)
;  9 = right
; 11 = up
; 13 = down
;  4,[0|1] = enable/disable vertical scroll
; 10 = line feed
; 12 = cls
; 22,y,x = Move to position
;


		SECTION		code_clib
		PUBLIC		fputc_generic
		PUBLIC		_fputc_generic
		PUBLIC		fputc_generic_setmode
		PUBLIC		_fputc_generic_setmode

		EXTERN		CONSOLE_ROWS
		EXTERN		CONSOLE_COLUMNS
		EXTERN		generic_console_scrollup
		EXTERN		generic_console_printc
		EXTERN		generic_console_cls

; void fputc_generic_setmode(char raw) __z88dk_fastcall
;
; Put the console into raw mode so characters passed through verbatim
fputc_generic_setmode:
_fputc_generic_setmode:
	ld	a,l
	ld	hl,flags
	res	6,(hl)
	and	a
	ret	z
	set	6,(hl)
	ret


; extern int __LIB__ fputc_cons(char c);
fputc_generic:
_fputc_generic:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	bc,(generic_x)		;coordinates
	ld	hl,flags
	bit	0,(hl)
	jr	nz,set_y
	bit	1,(hl)
	jr	nz,set_x
	bit	2,(hl)
	jr	nz,set_vscroll
	bit	6,(hl)		;raw mode
	ld	e,1		;set raw mode
	jr	nz,handle_character
	cp	8
	jr	z,left
	cp	9
	jr	z,right
	cp	10
	jp	z,handle_cr
	cp	11
	jr	z,up
	cp	12
	jr	z,cls
	cp	13
	jr	z,down
	cp	22
	jr	z,start_xypos
	cp	4
	jr	z,start_vscroll
	ld	e,0		;translate mode
handle_character:
	; At this point:
	;hl = flags
	; c = x position 
	; b = y position
	; a = character to print
	; e = raw character mode
	ld	d,a
	ld	a,b
	cp	CONSOLE_ROWS
	jr	c,handle_character_no_scroll
	bit	7,(hl)
	call	z,generic_console_scrollup
	ld	bc, +(CONSOLE_ROWS-1) * 256
	ld	(generic_x),bc
handle_character_no_scroll:
	ld	a,d
	push	bc		;save coordinates
	call	generic_console_printc
	pop	bc	
	inc	c
	ld	a,CONSOLE_COLUMNS
	jr	nz,store_position
	ld	c,0
	inc	b
store_position:
	ld	(generic_x),bc
	ret


set_x:
	res	1,(hl)
	sub	32
	cp	CONSOLE_COLUMNS
	ret	nc			;out of range
	ld	(generic_x),a
	ret
set_y:
	res	0,(hl)
	sub	32
	cp	CONSOLE_ROWS
	ret	nc			;out of range
	ld	(generic_y),a
	ret

set_vscroll:
	res	2,(hl)
	res	7,(hl)
	rrca
	ret	c
	set	7,(hl)
	ret

; Move print position left
left:	ld	a,c
	and	a
	jr	nz,left_1
	ld	c,CONSOLE_COLUMNS - 1
	jr	up
left_1: dec	a
	ld	(generic_x),a
	ret

; Move print position up
up:	ld	a,b
	and	a
	jr	z,up_1
	dec	b
up_1:	ld	(generic_x),bc
	ret

down:	ld	a,b
	cp	CONSOLE_ROWS - 1
	ret	z
	inc	a
	ld	(generic_y),a
	ret

right:	ld	a,c
	cp	CONSOLE_COLUMNS - 1
	ret	z
	dec	a
	ld	(generic_y),a
	ret


cls:	call	generic_console_cls
	ld	hl,0
	ld	(generic_x),hl
	ret

start_xypos:
	ld	a,(hl)
	or	3
	ld	(hl),a
	ret

start_vscroll:
	set	2,(hl)
	ret
	


handle_cr:
	ld	a,b
	cp	CONSOLE_ROWS - 1
	jr	nz,handle_cr_no_need_to_scroll
	; Check if scroll is enabled
	ld	a,(flags)
	rlca
	call	nc,generic_console_scrollup

	ld	b,CONSOLE_ROWS - 2
handle_cr_no_need_to_scroll:
	inc	b
	ld	c,0
	ld	(generic_x),bc
	ret





	


		SECTION		bss_clib

generic_x:	defb	0
generic_y:	defb	0
flags:		defb	0		; bit 0 = set x
					; bit 1 = set y
					; bit 2 = set vertical scroll
					; bit 6 = raw mode
					; bit 7 = vertical scroll disabled

