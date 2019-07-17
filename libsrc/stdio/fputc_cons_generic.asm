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
;  ![ESC] I - Move the cursor to beginning of line above.
;  *[ESC] J - Erase all lines after our current line
;  *[ESC] K - Clear the current line from the current cursor position.
;  [ESC] Y - row col 'Goto' Coordinate mode - first will change line number, then cursor position (both ASCII - 32)
;  [ESC] b - Byte after 'b' sets new foreground color (ASCII - 32)
;  [ESC] c - Byte after 'c' sets new background color (ASCII -32)
;  [ESC] p - start inverse video
;  [ESC] q - stop inverse video
;  [ESC] s - Enable/disable vertical scrolling
;  [ESC] r [char] - Print character (raw)
;   8      - move cursor left
;  10      - linefeed
;  12 = cls
;
; Supported ZX Codes:
;
;  4,[0|1] = enable/disable vertical scroll
;  8 = backspace 
;  9 = right
; 10 = line feed
; 11 = up
; 13 = down
; 16, 32 +n = set ink
; 17, 32 +n = set paper
; 22,y+32,x+32 = Move to position


IF !__CPU_8080__
		defc		SUPPORT_vt52=1
		; Extra VT52 codes - clear to end of line + clear to end of screen
		defc		SUPPORT_vt52x=0
		defc		SUPPORT_zxcodes=1


		SECTION		code_clib
		PUBLIC		fputc_cons_generic
		PUBLIC		_fputc_cons_generic

		; Variables that can be adjusted by platform specific code
		PUBLIC		generic_console_flags

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



; extern int __LIB__ fputc_cons(char c);
fputc_cons_generic:
_fputc_cons_generic:
	ld	hl,2
	add	hl,sp
	ld	d,(hl)
IF __CPU_8080__
	ld	hl,(__console_x)
	ld	c,l
	ld	b,h
ELSE
	ld	bc,(__console_x)		;coordinates
ENDIF
	ld	hl,params_left
	ld	a,(hl)
	and	a
	jr	nz,handle_parameter

	; Check for raw flag here
	ld	a,(generic_console_flags)
	ld	e,1
	rrca
	jr	nz,handle_character
	
	dec	e				;-> e = 0 (look at zxcodes)
	call	check_parameters		;Leaves e untouched
	ret	c				;Return if we processed the escape/it was a valid escape
handle_character:
	ld	hl,generic_console_flags
	; At this point:
	;hl = generic_console_flags
	; c = x position 
	; b = y position
	; d = character to print
	; e = raw character mode
	ld	a,(__console_h)
	cp	b
	jr	nz,handle_character_no_scroll
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


; Entry: hl = flags
;         d = character
IF SUPPORT_vt52
set_escape:
	; We need to look at the escape table now
	ld	e,1			;Consider ANSI side
	call	check_parameters
	ret	c		; Processed
	; Just print it in raw mode then
print_raw:
	ld	e,1
	jr	handle_character
ENDIF

handle_parameter:
	dec	(hl)
	jr	z,parameter_dispatch
	inc	hl	;Now points to parameters
	ld	(hl),d
	ret
parameter_dispatch:
	ld	hl,(parameter_processor)
	ld	a,d		;Get parameter into a
do_dispatch:
	push	hl
	ld	hl,generic_console_flags
	ret

check_parameters:
	ld	hl,parameter_table
parameter_loop:
	ld	a,(hl)
	inc	hl
IF SUPPORT_vt52
	bit	0,e
	jr	z,not_ansi
	ld	a,(hl)
not_ansi:
ENDIF
	inc	hl		;points to parameter count now
	and	a		;nc
	ret	z
	cp	255
	jr	z,try_again
	cp	d
	jr	nz, try_again
	; We matched a command
	ld	a,(hl)
	ld	(params_left),a
	ld	e,a
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	(parameter_processor),hl
	ld	a,e
	and	a		;Immediate action?
	ld	a,d		;The character
	ccf
	jr	z,do_dispatch
	ret
try_again:
	inc	hl
	inc	hl
	inc	hl
	jr	parameter_loop



; hl = flags
; bc = coordinates
;  d = x
; (parameter) = y
set_xypos:
	ld	hl,(__console_w)		;l = width, h = height
	ld	a,d
	sub	32
	ld	c,a
	ld	a,l
	dec	a
	cp	c
	ret	c		;out of range
	ld	a,(parameters)
	sub	32
	ld	b,a
	ld	a,h
	dec	a
	cp	b
	ret	c	;out of range
	jr	store_coords

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
	scf
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

set_vscroll:
	res	6,(hl)
	rrca
	ret	c
	set	6,(hl)
	scf
	ret

set_ink:
	call	generic_console_set_ink
	scf	
	ret

set_paper:
	call	generic_console_set_paper
	scf	
	ret


cls:	call	generic_console_cls
move_home:
	ld	bc,0
	jr	store_coords

IF SUPPORT_vt52
set_inverse_ansi:
	dec	a		;p = 70 = on, q = 71 = off
ENDIF
set_inverse:			;Entry hl = flags
	rl	(hl)		;drop bit 7
	rra
	rr	(hl)		;get it back again
set_inverse_call_generic:
	call	generic_console_set_inverse
	scf
	ret


IF SUPPORT_vt52x
; bc = coordinates
clear_eol:
	ld	a,b
clear_eol_loop:
	push	af		;save row
	ld	e,0		;not raw
	ld	a,' '
	call	handle_character	;exits with bc=coordinates
	pop	af
	cp	b
	jr	nz,clear_eol_loop
	scf
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
	scf
	ret
ENDIF


handle_cr:
	ld	a,(__console_h)
	dec	a
	cp	b
	jr	nz,handle_cr_no_need_to_scroll
	; Check if scroll is enabled
	bit	6,(hl)
	call	nc,generic_console_scrollup

	ld	a,(__console_h)
	sub	2
	ld	b,a
handle_cr_no_need_to_scroll:
	inc	b
	ld	c,0
	jr	store_coords






	SECTION	rodata_clib

; defb ZXCode, ANSICode
; defb paramater_count
; defw process_routine
;
; If code is 255 then not valid for this mode, so skip
parameter_table:
IF SUPPORT_vt52
	defb	27,255	;ESC
	defb	1	;We expect one parameter
	defw	set_escape
ENDIF
	defb	8, 8
	defb	0
	defw	left
	defb	10, 10
	defb	0
	defw	handle_cr
	defb	12, 12
	defb	0
	defw	cls

	defb	9, 'D'
	defb	0
        defw	right
        defb	11, 'A'
	defb	0
        defw	up
        defb	13, 'B'
	defb	0
        defw	down
IF SUPPORT_vt52
        defb	255, 'D'
	defb	0
        defw	left
ENDIF
        defb	22, 'Y'
	defb	2
	defw	set_xypos
IF SUPPORT_vt52
	defb	255, 'E'
	defb	0
	defw	cls
	defb	255, 'H'
	defb	0
	defw	move_home
ENDIF
	defb	4 , 's'
	defb	1
	defw	set_vscroll
	defb	16, 'b'
	defb	1
	defw	set_ink
	defb	17, 'c'
	defb	1
	defw	set_paper
IF SUPPORT_zxcodes
	defb	20, 255
	defb	1
	defw	set_inverse
ENDIF
IF SUPPORT_vt52
	defb	255, 'p'
	defb	0
	defw	set_inverse_ansi
	defb	255, 'q'
	defb	0
	defw	set_inverse_ansi
ENDIF
IF SUPPORT_vt52x
	defb	255, 'K'
	defb	0
	defw	clear_eol
	defb	255,'J'
	defb	0
	defw	clear_eos
ENDIF
IF SUPPORT_vt52
	defb	255, 'r'
	defb	1
	defw	print_raw
ENDIF
	defb	0	;endmarker

		SECTION		bss_clib

params_left:	defb	0		; Number of parameters left to read
parameters:	defb	0		; We only have up-to two parameters
parameter_processor:	defw	0	; Where we go to when we need to process

generic_console_flags:		defb	0		; bit 0 = raw mode enabled
							; bit 6 = vscroll disabled
							; bit 7 = inverse on

ENDIF
