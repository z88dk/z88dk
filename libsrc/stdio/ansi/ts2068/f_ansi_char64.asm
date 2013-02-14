;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	** alternate (smaller) 4bit font capability: 
;	** use the -DPACKEDFONT flag
;	** ROM font -DROMFONT
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display

	XLIB	ansi_CHAR

	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows

; Dirty thing for self modifying code
	XDEF	INVRS	
	XDEF	BOLD
	XDEF	UNDERLINE

.text_cols   defb 64
.text_rows   defb 24

.ansi_CHAR
	ld (char+1),a
	ld a,(ansi_ROW)       ; Line text position
	ld c,a
	and 24
	ld d,a
	ld a,c
	and 7
	rrca
	rrca
	rrca
	ld e,a
	ld hl,16384
	add hl,de

	ld a,(ansi_COLUMN)
	srl a
	jr nc,first_display
	set 5,h
.first_display
	add a,l
	ld l,a
;;	ld (RIGA+1),hl
;;.RIGA           ; Location on screen
;;	ld hl,16384
	push hl
.char
	ld e,'A'      ; Put here the character to be printed
	ld d,0

IF ROMFONT
	ld hl,15360
ELSE
	ld hl,font-256
ENDIF
	ld b,8

.LFONT
	add hl,de
	djnz LFONT

	pop de; de - screen, hl - font
	ld b,8
.LOOP
	ld a,(hl)
.BOLD
	nop	;	rla
	nop	;	or (hl)
.INVRS
;  cpl           ; Set to NOP to disable INVERSE
	nop

	ld (de),a
	inc d
	inc hl
	djnz LOOP
.UNDERLINE
	ret ; set to nop for underline
	dec d
	ld a,255
	ld (de),a
	ret
; end of underlined text handling

.font
IF ROMFONT
	; nothing here !
ELSE
	BINARY  "stdio/ansi/F8.BIN"
ENDIF
