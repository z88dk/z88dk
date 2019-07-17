;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;	Original code by maruhiro, 2007
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char_850.asm $
;


	SECTION  code_clib	

	PUBLIC	ansi_CHAR
	
	EXTERN	__console_w
	EXTERN	__console_h

	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	ansifont

	EXTERN	CONSOLE_COLUMNS
	EXTERN	CONSOLE_ROWS

	
	PUBLIC	init_screen
	PUBLIC	scroll_up
	PUBLIC	screenmode
	
IF USE_ATTR
	EXTERN	g850_attr
ENDIF



defc SCREENMODE_VISIBLECURSOR_MASK=0x01
defc SCREENMODE_VISIBLECURSOR_BIT=0




.ansi_CHAR
_print_char:
	ld de,(__console_x)
	; D=x; E=Y
	push	ix	;save callers
;	push BC
;	push HL
	push DE
	call vram_addr
	ld (HL), A
	
IF USE_ATTR
	ld	de,attr-vram
	add hl,de
	ld	a,(g850_attr)
	ld	(hl),a
ENDIF

	pop DE
	call update_vcell
;	pop HL
;	pop BC
	pop	ix	;restore callers
	ret

	

;
; Display status
;
; Input
; B: Real screen column number
; C: Output pattern
;
; Output
; Destroys: AF, BC
;
putstat:
	push BC
putstat_loop:
	in A, (0x40)
	rlca
	jr C, putstat_loop

	xor A
	out (0x40), A
	ld A, 0x19
	out (0x40), A

	ld A, (0x790d)
	add B
	and 0x0f
	or 0xb0
	out (0x40), A

	ld A, C
	out (0x41), A
	
	pop BC
	ret

;
; Display a pattern
;
; Input
; D: Line number of real screen
; E: Column number of the virtual screen
;
; Output
; Destroys: AF, BC, HL
;

putpat:
	ld C, 0x40
putpat_wait:
	in A, (C)
	rlca
	jr C, putpat_wait

	; Set X coordinate (lower order)
	
	ld A, E
	rlca
	rlca
	ld B, A
	and 0x0f
	out (C), A
	; Set X coordinate (upper)
	ld A, B
	and 0xf0
	rrca
	rrca
	rrca
	rrca
	or 0x10
	out (C), A
	
	; Set Y coordinate
	ld A, (0x790d)
	add D
	and 0x07
	or 0xb0
	out (C), A

	; Display a pattern
	inc C
	ld HL, pattern
	outi
	outi
	outi
	outi

	; Erase the pattern buffer
	xor A
	dec HL
	ld (HL), A
	dec HL
	ld (HL), A
	dec HL
	ld (HL), A
	dec HL
	ld (HL), A
	ret

pattern:
	defb 0, 0, 0, 0, 0, 0, 0, 0

;
; Cursor position?
;
; Input
; DE: Position to examine
;
; Output
; BC: Destroyed
; Z: Cursor position NZ: Not at cursor position
;
is_cur:
	; Cursor position?
	ld C, A
	ld A, (cursor_x)
	cp E
	jr NZ, is_cur_last
	ld A, (cursor_y)
	cp D
	jr NZ, is_cur_last
	; Is the cursor hidden?
	ld A, (screenmode)
	cpl
	and SCREENMODE_VISIBLECURSOR_MASK
	jr NZ, is_cur_last
	; Flashing cursor
	in A, (0x14)
	neg
is_cur_last:
	ld A, C
	ret

;
; Get font offset
;
; Input
; A: letter
;
; Output
; AF: destroyed
; BC: offset
;

font_offset:
	; Can it be displayed?
	ld B, A
	and 0x60
	ld A, B
	ld BC, 0x00a0
	ret Z
	; ????
	sub 0x20
	cp 0x60
	jr C, font_offset_alphabet
	sub 0x20
	; Is it possible to display?
	cp 0xa0
	ret NC
font_offset_alphabet:
	ld C, A
	ret

;
; Setting attributes
;
; Input
; C: attribute
; H: inverted pattern
; L: Underline pattern
; IY: font address
;
; Output
; AF: destroyed
; C: Attribute pattern
; IY: font address
;
setattr:
IF USE_ATTR
	xor A
	ld (font_bold + 0), A
	ld (font_bold + 1), A

	; Inversion?
	srl C
	jr NC, setattr_no_reverse
	xor H
setattr_no_reverse:

	; Is it underlined?
	srl C
	jr NC, setattr_no_underline
	xor L
setattr_no_underline:

	; Is it blinking?
	srl C
	jr NC, setattr_no_blink
	ld C, A
	in A, (0x14)
	or A
	ld A, C
	jr Z, setattr_no_blink
	ld IY, ansifont
setattr_no_blink:

	; Is it bold?
	srl C
	ld C, A
	jr NC, setattr_no_bold
	ld A, (IY+1)
	ld (font_bold + 0), A
	ld A, (IY+2)
	ld (font_bold + 1), A
setattr_no_bold:
ENDIF

	; Is it a cursor position?
IF USE_ATTR
ELSE
	ld C, 0
ENDIF
	push BC
	call is_cur
	pop BC
	ret NZ
	ld A, C
	xor H
	ld C, A
	ret
	
IF USE_ATTR
font_bold:
	defb 0, 0
ENDIF

;
; Shift A register
;
; Input
; A: number shifted
; B: Amount to shift
;
; Output
; A: number shifted
; F: destroyed
;
shift_a:
	push BC
	inc B
	dec B
	jr Z, shift_a_last
	jp P, shift_a_left
shift_a_right:
	; ????
	ld C, A
	ld A, B
	neg
	ld B, A
	ld A, C
shift_a_right0:
	srl A
	djnz shift_a_right0
	pop BC
	ret
shift_a_left:
	; ????
	sla A
	djnz shift_a_left
shift_a_last:
	pop BC
	ret

;
; Write to the pattern buffer (3 x 5 font)
;
; Input
; A: letter
; B: shift
; C: attribute
; DE: virtual screen coordinates
;
; Output
; AF, HL, IY: Destroyed
;
setpat3x5:
	push IY

	; Get font address
	push BC
	ld IY, ansifont
	call font_offset
	add IY, BC
	add IY, BC
	add IY, BC
	pop BC
	ld HL, 0x3f20
	call setattr

	; Write 1st byte
	ld HL, pattern
	ld A, (IY+0)
	xor C
	call shift_a
	or (HL)
	ld (HL), A

	; Write the second byte	
	inc HL
	ld A, (IY+1)
	xor C
	call shift_a
	or (HL)
	ld (HL), A

	; Write the third byte
	inc HL
	ld A, (IY+2)
IF USE_ATTR
	ld IY, font_bold
	or (IY+0)
ENDIF
	xor C
	call shift_a
	or (HL)
	ld (HL), A

	; Write 4th byte
IF USE_ATTR
	inc HL
	ld A, (font_bold + 1)
	or (IY+1)
	xor C
	call shift_a
	or (HL)
	ld (HL), A
ENDIF
	pop IY
	ret



;
; The contents of the virtual VRAM are reflected in the real VRAM
;
; Input
; D: actual screen Y coordinate
; E: X coordinate of the virtual screen
;
; Output
; AF, BC, DE, HL, IX, IY: Destroyed
;
update_cell:
	; font size?
	ld A, (__console_h)
	cp CONSOLE_ROWS
	jp Z, update_cell_3x5

;
; 36 x 8 screen
;
update_cell_3x5_0:
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, 0
	ld D, B
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 6
	inc D
	call setpat3x5
	dec D
	jp putpat
	
update_cell_3x5:
	ld B, 0
	ld C, E
	ld IX, vram0
IF USE_ATTR
	ld IY, attr0
ENDIF
	add IX, BC
IF USE_ATTR
	add IY, BC
ENDIF
	ld BC, CONSOLE_COLUMNS
	inc D
	dec D
	jr Z, update_cell_3x5_0
	add IX, BC
IF USE_ATTR
	add IY, BC
ENDIF
	dec D
	jr Z, update_cell_3x5_1
	add IX, BC
IF USE_ATTR
	add IY, BC
ENDIF
	dec D
	jr Z, update_cell_3x5_2
	add IX, BC
	add IX, BC
IF USE_ATTR
	add IY, BC
	add IY, BC
ENDIF
	dec D
	jr Z, update_cell_3x5_3
	add IX, BC
IF USE_ATTR
	add IY, BC
ENDIF
	dec D
	jr Z, update_cell_3x5_4
	add IX, BC
IF USE_ATTR
	add IY, BC
ENDIF
	dec D
	jr Z, update_cell_3x5_5
	ret
update_cell_3x5_1:
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, -2
	ld D, 1
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 4
	inc D
	call setpat3x5
	dec D
	jr update_cell_3x5_last
update_cell_3x5_2:
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, -4
	ld D, 2
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 2
	inc D
	call setpat3x5
	dec D
	jr update_cell_3x5_last
update_cell_3x5_3:
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, 0
	ld D, 4
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 6
	inc D
	call setpat3x5
	ld D, 3
	jr update_cell_3x5_last
update_cell_3x5_4:
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, -2
	ld D, 5
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 4
	inc D
	call setpat3x5
	ld D, 4
	jr update_cell_3x5_last
update_cell_3x5_5:
	push BC
	ld A, (IX+0)
IF USE_ATTR
	ld C, (IY+0)
ENDIF
	ld B, -4
	ld D, 6
	call setpat3x5
	ld A, (IX+CONSOLE_COLUMNS*1)
IF USE_ATTR
	ld C, (IY+CONSOLE_COLUMNS*1)
ENDIF
	ld B, 2
	inc D
	call setpat3x5
	ld D, 5
update_cell_3x5_last:
	jp putpat



;
; wait a bit
;
; Input
; None
;
; Output
; None
;
wait:
	push BC
	ld B, 100
wait_loop:
	djnz wait_loop
	pop BC
	ret

;
; Get the address of the virtual VRAM
;
; Input
; A: y coordinate
;
; Output
; DE: Virtual VRAM address
; AF, IX: Destroyed
;
vram_addr_row:
	add A
	ld D, 0
	ld E, A
	ld IX, row_table
	add IX, DE
	ld D, (IX+1)
	ld E, (IX+0)
	ret

row_table:
	defw vram0
	defw vram1
	defw vram2
	defw vram3
	defw vram4
	defw vram5
	defw vram6
	defw vram7
	defw vram_last

;
; Get the address of the virtual VRAM
;
; Input
; DE: virtual screen coordinates
;
; Output
; F, BC, IX: Destroyed
; HL: Virtual VRAM address
;
vram_addr:
	push AF
	push DE
	ld H, 0
	ld L, E
	ld A, D
	call vram_addr_row
	add HL, DE
	pop DE
	pop AF

	; Is it within range?
	or A
	push HL
	ld BC, vram_last
	sbc HL, BC
	pop HL
	jp P, vram_addr_err
	ret
vram_addr_err:
	; Out of range
	ld HL, vram_err
	ret

;
; ??
; A:??
;
; ??
; BC:VRAM????
; AF,IX:??
;
vram_size:
	add A
	ld B, 0
	ld C, A
	ld IX, vram_size_table
	add IX, BC
	ld B, (IX+1)
	ld C, (IX+0)
	ret

vram_size_table:
	defw CONSOLE_COLUMNS * 0
	defw CONSOLE_COLUMNS * 1
	defw CONSOLE_COLUMNS * 2
	defw CONSOLE_COLUMNS * 3
	defw CONSOLE_COLUMNS * 4
	defw CONSOLE_COLUMNS * 5
	defw CONSOLE_COLUMNS * 6
	defw CONSOLE_COLUMNS * 7
	defw CONSOLE_COLUMNS * 8

;
; Initialize the screen
;
; Input
; None
;
; Output
; AF, BC, DE, HL: Destroyed
;
init_screen:
	; Initialize update position
	ld HL, 0
	ld (update_loc), HL
	; Initialize screen area
	ld A, (__console_h)
	dec A
	ld L, A
	ld (screen_region), HL
	; Initialize mode
	;ld A, SCREENMODE_VISIBLECURSOR_MASK
	xor A
	ld (screenmode), A
	ld DE, 0
	ld (cursor_location), DE
	; Erase the screen
	ld BC, 0x0700
init_screen_loop:
	call putstat
	djnz init_screen_loop
	call putstat
	call clear_screen
	jp refresh_screen

;
; Erase the entire screen
;
; Input
; None
;
; Output
; AF, BC, HL: Destroyed
;
clear_screen:
	ld HL, CONSOLE_ROWS - 1

;
; Delete the scroll area of the screen
;
; Input
; H: upper line
; L: lower line
;
; Output
; AF, BC, HL: Destroyed
;
clear_region:
	push DE

	; BC
	ld A, L
	inc A
	sub H
	call vram_size
	; DE
	ld A, H
	call vram_addr_row
	call clear_region0

	pop DE
	ret

;
; Clear specified address / length range
;
; Input
; BC: length
; DE: Start address
;
; Output
; AF, BC, DE, HL: Destroyed
;
clear_region0:
	; Return if length is 0
	ld A, B
	or C
	ret Z
	
	; Is the length one?
	dec BC
	xor A
	cp B
	jr NZ, clear_region0_skip
	cp C
	jr NZ, clear_region0_skip
	
	; Delete one character
	ex DE, HL
	ld (HL), ' '
IF USE_ATTR
	; Delete one attribute
	;ld BC, (CONSOLE_COLUMNS * 8 + 8)
	ld	bc,attr-vram
	add HL, BC
	ld (HL), 0
ENDIF
	ret

clear_region0_skip:
	; Erase characters
	ld H, D
	ld L, E
	inc DE
IF USE_ATTR
	push BC
	push DE
	push HL
ENDIF
	ld (HL), ' '
	ldir

IF USE_ATTR
	; Delete attribute
	pop HL
	pop DE
	;ld BC, (CONSOLE_COLUMNS * 8 + 8)
	ld	bc,attr-vram
	add HL, BC
	ex DE, HL
	add HL, BC
	ex DE, HL
	pop BC
	ld (HL), 0
	ldir
ENDIF
	ret

;
; Execute ldir for virtual VRAM
;
; Input
; BC: Counter
; DE: Source address
; HL: Forwarding address
;
; Output
; BC: 0
; DE: Before execution DE + BC
; HL: Before execution HL + BC
;
ldir_screen:
IF USE_ATTR
	push BC
	push DE
	push HL
	ldir
	pop HL
	pop DE
	;ld BC, (CONSOLE_COLUMNS * 8 + 8)
	ld	bc,attr-vram
	add HL, BC
	ex DE, HL
	add HL, BC
	ex DE, HL
	pop BC
	ldir

	;ld BC, -(CONSOLE_COLUMNS * 8 + 8)
	ld	bc,-(attr-vram)
	add HL, BC
	ex DE, HL
	add HL, BC
	ex DE, HL
	ld BC, 0
	ret
ELSE
	ldir
	ret
ENDIF



;
; Scroll up the virtual VRAM
;
; Input
; None
;
; Output
; AF, BC, HL: Destroyed
;
scroll_up:
	ld HL, 7
	ld C, 1

;
; Scroll up the virtual VRAM by specifying the range and number of times
;
; Input
; C: number of lines to scroll
; H: upper line
; L: lower line
;
; Output
; AF, BC, HL: Destroyed
;
scroll_up0:
	; (BC)
	ld A, L
	sub H
	sub C
	jp C, clear_region
	push DE
	push AF

	; DE
	ld A, H
	call vram_addr_row

	; HL
	ld A, C
	call vram_size
	ld H, D
	ld L, E
	add HL, BC

	; BC
	pop AF
	push BC
	inc A
	call vram_size

	; Execute scroll up
	call ldir_screen
	pop BC
	or A
	sbc HL, BC
	ex DE, HL
	call clear_region0
	
	pop DE
	;ret
	jp refresh_screen



;
; Reflect the contents of the virtual VRAM in the real VRAM
;
; Input
; DE: the coordinates of the virtual screen
;
; Output
; AF, BC, DE, HL, IX, IY: Destruction
;
;
update_vcell:
	ld A, D
	ld D, 0
	or A
	jp Z, update_cell_3x5
	dec A
	jr Z, putch1
	inc D
	dec A
	jr Z, putch2
	inc D
	dec A
	jp Z, update_cell_3x5
	inc D
	dec A
	jp Z, update_cell_3x5
	dec A
	jr Z, putch5
	inc D
	dec A
	jr Z, putch6
	inc D
	jp update_cell_3x5
putch1:
	push DE
	call update_cell_3x5
	pop DE
	inc D
	jp update_cell_3x5
putch2:
	push DE
	call update_cell_3x5
	pop DE
	inc D
	jp update_cell_3x5
putch5:
	push DE
	call update_cell_3x5
	pop DE
	inc D
	jp update_cell_3x5
putch6:
	push DE
	call update_cell_3x5
	pop DE
	inc D
	jp update_cell_3x5

;
; Update the screen
;
; Input
; None
;
; Output
; AF, BC, HL: Destruction
;
refresh_screen0:
	; Update (x, y)
	push DE
	ld HL, update_loc
	ld D, (HL)
	inc HL
	ld E, (HL)
	call update_cell
	pop DE
	
 	; x := x - 1, Return if x >= 0
	ld HL, update_x
	dec (HL)
	ret P
	
	; x := WIDTH - 1
	ld A, (__console_w)
	dec A
	ld (HL), A
	
	; y := y - 1, Return if y >= 0
	ld HL, update_y
	dec (HL)
	ret P
	
	; y := HEIGHT - 1
	ld (HL), 5
	ret
update_loc:
update_y:
	defb 0
update_x:
	defb 0

;
; Update the screen
;
; Input
; None
;
; Output
; AF, BC, HL: Destruction
;
refresh_screen:
	ld B, 144
refresh_screen_loop:
	push BC
	call refresh_screen0
	call refresh_screen0
	pop BC
	djnz refresh_screen_loop
	ret


	
; DATA section required, so we get a pre-initialized, scrollable region

	SECTION  data_clib
	
; Virtual VRAM
vram:
vram0:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram1:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram2:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram3:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram4:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram5:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram6:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram7:
	defb 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
vram_last:
vram_err:
vram8:
	defb 0, 0, 0, 0, 0, 0, 0, 0
IF USE_ATTR
attr:
attr0:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr1:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr2:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr3:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr4:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr5:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr6:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr7:
	defb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
attr_last:
attr8:
	defb 0, 0, 0, 0, 0, 0, 0, 0
ENDIF

;
; Screen up and down
;
screen_region:
screen_bottom:
	defb CONSOLE_ROWS - 1
screen_top:
	defb 0


;
; Cursor position
;
cursor_location:
cursor_x:
	defb 0
cursor_y:
	defb 0

;
; Mode
;
screenmode:
	defb 0


