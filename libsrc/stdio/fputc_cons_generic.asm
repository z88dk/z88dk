; Generic console driver - VT52 + ZX Codes
;
; Supported VT52 codes:
;
;  [ESC] A - Move the cursor to beginning of line above.
;  [ESC] B - Move the cursor to beginning of line below.
;  [ESC] C - Move the cursor right by one.
;  [ESC] D - Move the cursor left by one 
;  [ESC] E - Clear the screen and place the cursor in the upper left corner.
;  [ESC] H - Move the cursor to the upper left corner.
;  [ESC] I - Move the cursor to beginning of line above.
;  [ESC] J - Erase all lines after our current line
;  [ESC] K - Clear the current line from the current cursor position.
;  [ESC] Y - row col 'Goto' Coordinate mode - first will change line number, then cursor position (both ASCII - 32)
;  [ESC] b - Byte after 'b' sets new foreground color (ASCII - 32)
;  [ESC] c - Byte after 'c' sets new background color (ASCII -32)
;  [ESC] p - start inverse video
;  [ESC] q - stop inverse video
;  [ESC] s - Enable/disable vertical scrolling
;  [ESC] r [char] - Print character (raw)
;   8      - move cursor left
;  10      - linefeed
;
; Supported ZX Codes:
;
;  4,[0|1] = enable/disable vertical scroll
;  8 = backspace 
;  9 = right
; 10 = line feed
; 11 = up
; 12 = cls
; 13 = down
; 16, 32 +n = set ink
; 17, 32 +n = set paper
; 22,y+32,x+32 = Move to position

		defc		SUPPORT_vt52=1
		; Extra VT52 codes - clear to end of line + clear to end of screen
		defc		SUPPORT_vt52x=0
		defc		SUPPORT_zxcodes=1


		SECTION		code_clib
		PUBLIC		fputc_cons_generic
		PUBLIC		_fputc_cons_generic

		; Variables that can be adjusted by platform specific code
		PUBLIC		generic_console_flags
		PUBLIC		generic_console_flags2

		EXTERN		generic_console_scrollup
		EXTERN		generic_console_printc
		EXTERN		generic_console_cls
		EXTERN		generic_console_set_ink
		EXTERN		generic_console_set_paper
		EXTERN		generic_console_set_inverse
		EXTERN		__console_x
		EXTERN		__console_y
		EXTERN		__console_w
		EXTERN		__console_h

set_x:
	res	2,(hl)
	sub	32
	ld	b,a
	ld	a,(__console_w)
	dec	a
	cp	b
	ret	c		;out of range
	ld	a,b
	ld	(__console_x),a
	ret
set_y:
	res	1,(hl)
	sub	32
	ld	b,a
	ld	a,(__console_h)
	dec	a
	cp	b
	ret	c	;out of range
	ld	a,b
	ld	(__console_y),a
	ret

set_vscroll:
	res	3,(hl)
	inc	hl		;Now on flags2
	res	6,(hl)
	rrca
	ret	c
	set	6,(hl)
	ret

set_ink:
	res	4,(hl)
	jp	generic_console_set_ink

set_paper:
	res	5,(hl)
	jp	generic_console_set_paper

; extern int __LIB__ fputc_cons(char c);
fputc_cons_generic:
_fputc_cons_generic:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	bc,(__console_x)		;coordinates
	ld	hl,generic_console_flags
IF SUPPORT_vt52
	bit	0,(hl)
	jp	nz,set_escape
ENDIF
	bit	1,(hl)
	jr	nz,set_y
	bit	2,(hl)
	jr	nz,set_x
	bit	3,(hl)
	jr	nz,set_vscroll
	bit	4,(hl)
	jr	nz,set_ink
	bit	5,(hl)
	jr	nz,set_paper
	bit	6,(hl)
	jp	nz,set_inverse
	bit	7,(hl)
	res	7,(hl)
        ld      e,1             ;set raw mode
	jr	nz,handle_character
	inc	hl		;flags2
        bit     0,(hl)          ;raw mode
	dec	hl
        jr      nz,handle_character
        cp      8
        jp      z,left
        cp      10
        jp      z,handle_cr
        cp      12
        jr      z,cls
IF SUPPORT_zxcodes
        cp      9
        jp      z,right
        cp      11
        jp      z,up
        cp      13
        jp      z,down
        cp      22
	ld	d,6
        jr      z,start_code
        cp      4
	ld	d,8
        jr      z,start_code
	cp	16
	ld	d,16
	jr	z,start_code
	cp	17
	ld	d,32
	jr	z,start_code
	ld	d,64
	cp	20
	jr	z,start_code
ENDIF
IF SUPPORT_vt52
	ld	d,1
	cp	27
	jr	z,start_code
ENDIF
	dec	e		;e = 0, not raw mode
handle_character:
	; At this point:
	;hl = generic_console_flags
	; c = x position 
	; b = y position
	; a = character to print
	; e = raw character mode
	ld	d,a
	ld	a,(__console_h)
	cp	b
	jr	nc,handle_character_no_scroll
	inc	hl
	bit	6,(hl)
	call	z,generic_console_scrollup
	ld	a,(__console_h)
	dec	a
	ld	b,a
	ld	c,0
	ld	(__console_x),bc
handle_character_no_scroll:
	ld	a,d
	push	bc		;save coordinates
	call	generic_console_printc
	pop	bc	
	inc	c
	ld	a,(__console_w)
	cp	c
	jr	nz,store_coords
	ld	c,0
	inc	b
	jr	store_coords


start_code:
	ld	a,(hl)
	or	d
	ld	(hl),a
	ret

cls:	call	generic_console_cls
move_home:
	ld	bc,0
	jr	store_coords

IF SUPPORT_vt52
set_escape:
	res	0,(hl)
	jr	z,start_code
	cp	'A'
	jr	z,up
	cp	'B'
	jr	z,down
	cp	'C'
	jr	z,right
	cp	'D'
	jr	z,left
	cp	'E'
	jr	z,cls
	cp	'H'		;home
	jr	z,move_home
	cp	'Y'
	ld	d,6
	jr	z,start_code
IF SUPPORT_vt52x
	cp	'K'
	jr	z,clear_eol
	cp	'J'
	jr	z,clear_eos
ENDIF
	cp	'p'
	jr	z,set_inverse_ansi
	cp	'q'
	jr	z,set_inverse_ansi
	cp	'b'
	ld	d,16
	jr	z,start_code
	cp	'c'
	ld	d,32
	jr	z,start_code
	cp	's'
	ld	d,8
	jr	z,start_code
	cp	'r'
	ld	d,128
	jr	z,start_code
	; Anything else we just print
	ld	e,1			;Print in raw mode
	jr	handle_character
ENDIF

set_inverse_ansi:
	dec	a		;p = 70 = on, q = 71 = off
set_inverse:			;Entry hl = flags
	res	6,(hl)
	inc	hl		;hl = flags2
	rl	(hl)		;drop bit 7
	rra
	rr	(hl)		;get it back again
set_inverse_call_generic:
	jp	generic_console_set_inverse


; Move print position left
left:	ld	a,c
	and	a
	jr	nz,left_1
	ld	a,(__console_w)
	dec	a
	ld	c,a
	jr	up
left_1: dec	c
store_coords:
	ld	(__console_x),bc
	ret

; Move print position up
up:	ld	a,b
	and	a
	jr	z,store_coords
	dec	b
	jr	store_coords

down:	ld	a,(__console_h)
	dec	a
	cp	b
	ret	z
	inc	b
	jr	store_coords

right:	ld	a,(__console_w)
	dec	a
	cp	c
	ret	z
	inc	c
	jr	store_coords




IF SUPPORT_vt52x
; bc = coordinates
clear_eol:
	ld	a,b
clear_eol_loop:
	ld	hl,generic_console_flags
	push	af		;save row
	ld	e,0		;not raw
	ld	a,' '
	call	handle_character	;exits with bc=coordinates
	pop	af
	cp	b
	jr	nz,clear_eol_loop
	ret

; bc = coordinates
clear_eos:
	call	clear_eol		;exit, bc = coordinates
	ld	a,(__console_h)
	sub	b
clear_eos_loop:
	push	af
	call	clear_eol
	pop	af
	dec	a
	jr	nz,clear_eos_loop
	ret
ENDIF


handle_cr:
	ld	a,(__console_h)
	dec	a
	cp	b
	jr	nz,handle_cr_no_need_to_scroll
	; Check if scroll is enabled
	ld	a,(generic_console_flags)
	rlca
	call	nc,generic_console_scrollup

	ld	a,(__console_h)
	sub	2
	ld	b,a
handle_cr_no_need_to_scroll:
	inc	b
	ld	c,0
	jr	store_coords





		SECTION		bss_clib

generic_console_flags:		defb	0		; bit 0 = expect escape
							; bit 1 = expect row
							; bit 2 = expect column
							; bit 3 = expect vscroll
							; bit 4 = expect ink
							; bit 5 = expect paper
							; bit 6 = expect inverse
							; bit 7 = expect raw character
generic_console_flags2:		defb	0		; bit 0 = raw mode enabled
							; bit 6 = vscroll disabled
							; bit 7 = inverse on

