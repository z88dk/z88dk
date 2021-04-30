; Generic console driver - VT52 + ZX Codes
;
; Supported VT52 codes:
;
; * = With VT52x
;
;  [ESC] A - Move the cursor to beginning of line above.
;  [ESC] B - Move the cursor to beginning of line below.
;  [ESC] C - Move the cursor right by one.
;  [ESC] D - Move the cursor left by one 
;  [ESC] E - Clear the screen and place the cursor in the upper left corner.
;  [ESC] H - Move the cursor to the upper left corner.
;  // ![ESC] I - Move the cursor to beginning of line above.
;  *[ESC] J - Erase all lines after our current line
;  *[ESC] K - Clear the current line from the current cursor position.
;  [ESC] Y - row col 'Goto' Coordinate mode - first will change line number, then cursor position (both ASCII - 32)
;  [ESC] b - Byte after 'b' sets new foreground color (ASCII - 32)
;  [ESC] c - Byte after 'c' sets new background color (ASCII -32)
;  [ESC] p - start inverse video
;  [ESC] q - stop inverse video
;  *[ESC] 0 - start underlined
;  *[ESC] 1 - stop underlined
;  *[ESC] 2 - start bold
;  *[ESC] 3 - stop bold
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
; 13 = cr
; 16, 32 +n = set ink
; 17, 32 +n = set paper
; 22,y+32,x+32 = Move to position


		; Variables that can be adjusted by platform specific code
		EXTERN		generic_console_flags

		EXTERN		generic_console_scrollup
		EXTERN		generic_console_printc
		EXTERN		generic_console_cls
		EXTERN		generic_console_set_ink
		EXTERN		generic_console_set_paper
		EXTERN		generic_console_set_attribute
		EXTERN		generic_console_set_attribute
		EXTERN		__console_x
		EXTERN		__console_y
		EXTERN		__console_w
		EXTERN		__console_h



; extern int __LIB__ fputc_cons(char c);
	ld	hl,2
	add	hl,sp
	ld	d,(hl)
IF __CPU_INTEL__
	ld	hl,(__console_x)
	ld	c,l
	ld	b,h
ELIF __CPU_GBZ80__
	ld	hl,__console_x
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
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
;	jr	nz,handle_character
	
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
	dec	a
	cp	b
	jr	nc,handle_character_no_scroll
	sub	b
	neg
	ld	b,a
scroll_loop:
IF __CPU_INTEL__
	ld	a,(hl)
	rlca
	rlca
	call	nc,generic_console_scrollup
ELSE
	bit	6,(hl)
	call	z,generic_console_scrollup
ENDIF
	djnz	scroll_loop
	ld	a,(__console_h)
	dec	a
	ld	b,a
	ld	c,0
IF __CPU_GBZ80__ | __CPU_INTEL__
	ld	(__console_x+1),a		;a holds vlaue of b
	ld	a,c
	ld	(__console_x),a
ELSE
	ld	(__console_x),bc
ENDIF
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
IF __CPU_GBZ80__
	ld	hl,parameter_processor
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(parameter_processor)
ENDIF
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
  IF __CPU_INTEL__
        push   de
        ld     d,a
        ld     a,e
        rrca
        jp     nc,not_ansi
        ld     d,(hl)
not_ansi:
        ld     a,d
        pop    de
  ELSE
	bit	0,e
	jr	z,not_ansi
	ld	a,(hl)
not_ansi:
   ENDIF
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
IF __CPU_GBZ80__
	ld	(parameter_processor),a
	ld	a,h
	ld	(parameter_processor+1),a
ELSE
	ld	(parameter_processor),hl
ENDIF
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
IF __CPU_GBZ80__
	ld	hl,__console_w
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
ELSE
	ld	hl,(__console_w)		;l = width, h = height
ENDIF
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
IF __CPU_GBZ80__ | __CPU_INTEL__
	ld	a,c
	ld	(__console_x),a
	ld	a,b
	ld	(__console_x+1),a
ELSE
	ld	(__console_x),bc
ENDIF
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
IF __CPU_INTEL__
	ld	e,a
	ld	a,(hl)
	and	@10111111
	ld	(hl),a
	ld	a,e
	rrca
	ret	c
	ld	a,(hl)
	or	@01000000
	ld	(hl),a
	scf
	ret
ELSE
	res	6,(hl)
	rrca
	ret	c
	set	6,(hl)
ENDIF
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
IF __CPU_INTEL__
	ld	e,@01111111
	ld	d,@10000000
	rra
	jr	c,set_inverse_doit
	ld	d,@00000000
set_inverse_doit:
	ld	a,(hl)
	and	e
	or	d
	ld	(hl),a
ELSE
	rl	(hl)		;drop bit 7
	rra
	rr	(hl)		;get it back again
ENDIF
set_inverse_call_generic:
	call	generic_console_set_attribute
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


handle_lf:
	ld	a,(__console_h)
	dec	a
	sub	b
	jr	z,scrollit
	jr	nc,handle_lf_no_need_to_scroll
	; Check if scroll is enabled
scrollit:
IF __CPU_INTEL__
	ld	a,(hl)
	rlca
	rlca
	call	nc,generic_console_scrollup
ELSE
	bit	6,(hl)
	call	z,generic_console_scrollup
ENDIF

	ld	a,(__console_h)
	sub	2
	ld	b,a
handle_lf_no_need_to_scroll:
	inc	b
handle_cr:
	ld	c,0
	jp	store_coords



IF SUPPORT_vt52x
set_underlined_ansi:
	;'0' = 48 = on, '1' = 49 = off
	dec	a
	and	@00001000
	ld	c,a
	ld	a,(hl)
	and	@11110111
	or	c
	ld	(hl),a
call_set_attribute:
	call	generic_console_set_attribute
	scf
	ret

set_bold_ansi:
	;'2' = 50 = on, '3' = 51 = off
	sub	3	;So 47, 48
	and	@00001000
	rlca
	ld	c,a
	ld	a,(hl)
	and	@11101111
	or	c
	ld	(hl),a
	jr	call_set_attribute
ENDIF
	



	SECTION	rodata_clib

; defb ZXCode, ANSICode
; defb parameter_count
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
	defw	handle_lf
	defb	12, 12
	defb	0
	defw	cls
	defb	13, 13
	defb	0
	defw	handle_cr

	defb	9, 'D'
	defb	0
        defw	right
        defb	11, 'A'
	defb	0
        defw	up
        defb	255, 'B'
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
	defb	255, '0'
	defb	0
	defw	set_underlined_ansi
	defb	255, '1'
	defb	0
	defw	set_underlined_ansi
	defb	255, '2'
	defb	0
	defw	set_bold_ansi
	defb	255, '3'
	defb	0
	defw	set_bold_ansi
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
