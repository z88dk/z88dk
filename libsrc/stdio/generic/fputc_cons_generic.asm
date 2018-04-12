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
		PUBLIC		fputc_cons_generic
		PUBLIC		_fputc_cons_generic
		PUBLIC		fputc_cons_generic_setmode
		PUBLIC		_fputc_cons_generic_setmode

		; Variables that can be adjusted by platform specific code
		PUBLIC		generic_console_w
		PUBLIC		generic_console_h

		EXTERN		CONSOLE_ROWS
		EXTERN		CONSOLE_COLUMNS
		EXTERN		generic_console_scrollup
		EXTERN		generic_console_printc
		EXTERN		generic_console_cls

; void fputc_generic_setmode(char raw) __z88dk_fastcall
;
; Put the console into raw mode so characters passed through verbatim
fputc_cons_generic_setmode:
_fputc_cons_generic_setmode:
	ld	a,l
	ld	hl,flags
	res	6,(hl)
	and	a
	ret	z
	set	6,(hl)
	ret


; extern int __LIB__ fputc_cons(char c);
fputc_cons_generic:
_fputc_cons_generic:
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
	jp	z,right
	cp	10
	jp	z,handle_cr
	cp	11
	jr	z,up
	cp	12
	jp	z,cls
	cp	13
	jr	z,down
	cp	22
	jp	z,start_xypos
	cp	4
	jp	z,start_vscroll
	ld	e,0		;translate mode
handle_character:
	; At this point:
	;hl = flags
	; c = x position 
	; b = y position
	; a = character to print
	; e = raw character mode
	ld	d,a
	ld	a,(generic_console_h)
	cp	b
	jr	nc,handle_character_no_scroll
	bit	7,(hl)
	call	z,generic_console_scrollup
	ld	a,(generic_console_h)
	dec	a
	ld	b,a
	ld	c,0
	ld	(generic_x),bc
handle_character_no_scroll:
	ld	a,d
	push	bc		;save coordinates
	call	generic_console_printc
	pop	bc	
	inc	c
	ld	a,(generic_console_w)
	cp	c
	jr	nz,store_coords
	ld	c,0
	inc	b
	jr	store_coords


set_x:
	res	1,(hl)
	sub	32
	ld	b,a
	ld	a,(generic_console_w)
	cp	b
	ret	c		;out of range
	ld	a,b
	ld	(generic_x),a
	ret
set_y:
	res	0,(hl)
	sub	32
	ld	b,a
	ld	a,(generic_console_h)
	cp	b
	ret	c	;out of range
	ld	a,b
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
	ld	a,(generic_console_w)
	dec	a
	ld	c,a
	jr	up
left_1: dec	c
store_coords:
	ld	(generic_x),bc
	ret

; Move print position up
up:	ld	a,b
	and	a
	jr	z,store_coords
	dec	b
	jr	store_coords

down:	ld	a,(generic_console_h)
	dec	a
	cp	b
	ret	z
	inc	b
	jr	store_coords

right:	ld	a,(generic_console_w)
	dec	a
	cp	c
	ret	z
	inc	c
	jr	store_coords


cls:	call	generic_console_cls
	ld	bc,0
	jr	store_coords

start_xypos:
	ld	a,(hl)
	or	3
	ld	(hl),a
	ret

start_vscroll:
	set	2,(hl)
	ret
	


handle_cr:
	ld	a,(generic_console_h)
	dec	a
	cp	b
	jr	nz,handle_cr_no_need_to_scroll
	; Check if scroll is enabled
	ld	a,(flags)
	rlca
	call	nc,generic_console_scrollup

	ld	a,(generic_console_h)
	sub	2
	ld	b,a
handle_cr_no_need_to_scroll:
	inc	b
	ld	c,0
	jr	store_coords





	
		SECTION		data_clib

generic_console_w:	defb	CONSOLE_COLUMNS
generic_console_h:	defb	CONSOLE_ROWS

		SECTION		bss_clib

generic_x:	defb	0
generic_y:	defb	0
flags:		defb	0		; bit 0 = set x
					; bit 1 = set y
					; bit 2 = set vertical scroll
					; bit 6 = raw mode
					; bit 7 = vertical scroll disabled

