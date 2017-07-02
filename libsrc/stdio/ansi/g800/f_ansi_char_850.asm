;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2017
;	Original code by maruhiro, 2007
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char_850.asm $
;

	SECTION  code_clib	
		
	PUBLIC	ansi_CHAR
	
	PUBLIC	text_cols
	PUBLIC	text_rows

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	
	PUBLIC	init_screen
	PUBLIC	scroll_up
	PUBLIC	screenmode

;ATTR_REVERSE_MASK=0x01
;ATTR_REVERSE_BIT=0
;ATTR_UNDERLINE_MASK=0x02
;ATTR_UNDERLINE_BIT=1
;ATTR_BLINK_MASK=0x04
;ATTR_BLINK_BIT=2
;ATTR_BOLD_MASK=0x08
;ATTR_BOLD_BIT=3
;ATTR_KANJIH_BIT=4
;ATTR_KANJIH_MASK=0x10
;ATTR_KANJIL_BIT=5
;ATTR_KANJIL_MASK=0x20

	
defc SMALL_WIDTH=36
defc SMALL_HEIGHT=8



defc SCREENMODE_VISIBLECURSOR_MASK=0x01
defc SCREENMODE_VISIBLECURSOR_BIT=0

;
; Screen size
;


;	EXTERN	ansirows
;.text_rows   defb ansirows
screen_width:
text_cols:
	defb SMALL_WIDTH
	
screen_height:
text_rows:
	defb SMALL_HEIGHT





.ansi_CHAR
_print_char:
	ld de,(ansi_COLUMN)
	; D=x; E=Y
;	push BC
;	push HL
	push DE
	call vram_addr
	ld (HL), A
	pop DE
	call update_vcell
;	pop HL
;	pop BC
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
	ld IY, font_blank
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
	ld IY, font3x5
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
	ld A, (screen_height)
	cp SMALL_HEIGHT
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	ld BC, SMALL_WIDTH
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	ld A, (IX+SMALL_WIDTH*1)
IF USE_ATTR
	ld C, (IY+SMALL_WIDTH*1)
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
	defw SMALL_WIDTH * 0
	defw SMALL_WIDTH * 1
	defw SMALL_WIDTH * 2
	defw SMALL_WIDTH * 3
	defw SMALL_WIDTH * 4
	defw SMALL_WIDTH * 5
	defw SMALL_WIDTH * 6
	defw SMALL_WIDTH * 7
	defw SMALL_WIDTH * 8

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
	ld A, (screen_height)
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
	ld HL, SMALL_HEIGHT - 1

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
	ld BC, (SMALL_WIDTH * 8 + 8)
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
	ld BC, (SMALL_WIDTH * 8 + 8)
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
	ld BC, (SMALL_WIDTH * 8 + 8)
	add HL, BC
	ex DE, HL
	add HL, BC
	ex DE, HL
	pop BC
	ldir

	ld BC, -(SMALL_WIDTH * 8 + 8)
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
	ld HL, (screen_region)
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
	ld A, (screen_width)
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


; 3x5????
font3x5:
font_blank:
	defb 0x00, 0x00, 0x00	;  
	defb 0x00, 0x17, 0x00	; !
	defb 0x03, 0x00, 0x03	; "
	defb 0x1f, 0x0a, 0x1f	; 
	defb 0x06, 0x1f, 0x0c	; $
	defb 0x09, 0x04, 0x12	; %
	defb 0x1b, 0x1f, 0x14	; &
	defb 0x02, 0x01, 0x00	; '
	defb 0x00, 0x0e, 0x11	; (
	defb 0x11, 0x0e, 0x00	; )
	defb 0x15, 0x0e, 0x15	; *
	defb 0x04, 0x0e, 0x04	; +
	defb 0x10, 0x08, 0x00	; ,
	defb 0x04, 0x04, 0x04	; -
	defb 0x00, 0x10, 0x00	; .
	defb 0x08, 0x04, 0x02	; /
	defb 0x0e, 0x15, 0x0e	; 0
	defb 0x02, 0x1f, 0x00	; 1
	defb 0x19, 0x15, 0x16	; 2
	defb 0x11, 0x15, 0x0a	; 3
	defb 0x07, 0x04, 0x1f	; 4
	defb 0x17, 0x15, 0x09	; 5
	defb 0x0e, 0x15, 0x08	; 6
	defb 0x01, 0x01, 0x1f	; 7
	defb 0x0a, 0x15, 0x0a	; 8
	defb 0x02, 0x05, 0x1e	; 9
	defb 0x00, 0x0a, 0x00	; :
	defb 0x10, 0x0a, 0x00	; :
	defb 0x04, 0x0a, 0x11	; <
	defb 0x0a, 0x0a, 0x0a	; =
	defb 0x11, 0x0a, 0x04	; >
	defb 0x01, 0x15, 0x02	; ?
	defb 0x09, 0x15, 0x0e	; @
	defb 0x1e, 0x05, 0x1e	; A
	defb 0x1f, 0x15, 0x0a	; B
	defb 0x0e, 0x11, 0x0a	; C
	defb 0x1f, 0x11, 0x0e	; D
	defb 0x1f, 0x15, 0x11	; E
	defb 0x1f, 0x05, 0x01	; F
	defb 0x0e, 0x11, 0x1d	; G
	defb 0x1f, 0x04, 0x1f	; H
	defb 0x11, 0x1f, 0x11	; I
	defb 0x08, 0x11, 0x0f	; J
	defb 0x1f, 0x0e, 0x11	; K
	defb 0x1f, 0x10, 0x10	; L
	defb 0x1f, 0x1e, 0x1f	; M
	defb 0x1f, 0x0e, 0x1f	; N
	defb 0x0e, 0x11, 0x0e	; O
	defb 0x1f, 0x05, 0x02	; P
	defb 0x0e, 0x19, 0x1e	; Q
	defb 0x1f, 0x0d, 0x12	; R
	defb 0x12, 0x15, 0x09	; S
	defb 0x01, 0x1f, 0x01	; T
	defb 0x1f, 0x10, 0x1f	; U
	defb 0x07, 0x18, 0x07	; V
	defb 0x0f, 0x1f, 0x0f	; W
	defb 0x1b, 0x04, 0x1b	; X
	defb 0x03, 0x1c, 0x03	; Y
	defb 0x19, 0x15, 0x13	; Z
	defb 0x00, 0x1f, 0x11	; [
	defb 0x02, 0x04, 0x08	; \
	defb 0x11, 0x1f, 0x00	; ]
	defb 0x02, 0x01, 0x02	; ^
	defb 0x10, 0x10, 0x10	; _
	defb 0x00, 0x01, 0x02	; `
	defb 0x0c, 0x12, 0x1e	; a
	defb 0x1f, 0x12, 0x0c	; b
	defb 0x0c, 0x12, 0x12	; c
	defb 0x0c, 0x12, 0x1f	; d
	defb 0x0e, 0x15, 0x16	; e
	defb 0x04, 0x1e, 0x05	; f
	defb 0x12, 0x15, 0x0e	; g
	defb 0x1f, 0x02, 0x1c	; h
	defb 0x00, 0x1d, 0x00	; i
	defb 0x08, 0x10, 0x1d	; j
	defb 0x1f, 0x08, 0x14	; k
	defb 0x00, 0x1f, 0x00	; l
	defb 0x1e, 0x1e, 0x1c	; m
	defb 0x1e, 0x02, 0x1c	; n
	defb 0x0c, 0x12, 0x0c	; o
	defb 0x1e, 0x0a, 0x04	; p
	defb 0x04, 0x0a, 0x1e	; q
	defb 0x1e, 0x04, 0x02	; r
	defb 0x14, 0x1e, 0x0a	; s
	defb 0x02, 0x0f, 0x12	; t
	defb 0x0e, 0x10, 0x1e	; u
	defb 0x0e, 0x18, 0x0e	; v
	defb 0x0e, 0x1e, 0x0e	; w
	defb 0x12, 0x0c, 0x12	; x
	defb 0x02, 0x14, 0x0e	; y
	defb 0x1a, 0x1e, 0x16	; z
	defb 0x04, 0x0e, 0x11	; {
	;defb 0x1f, 0x1f, 0x1f	; ¦
	defb 0x00, 0x1b, 0x00	; |
	defb 0x11, 0x0e, 0x04	; }
	;defb 0x15, 0x0a, 0x15	; check¦
	defb 0x01, 0x01, 0x01	; ~
	;defb 0x00, 0x00, 0x00	; 
	;defb 0x1f, 0x01, 0x1f	; p

	

	SECTION  bss_clib
	
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
	defb SMALL_HEIGHT - 1
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


