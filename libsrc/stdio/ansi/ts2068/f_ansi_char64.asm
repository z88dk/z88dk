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
;	.__console_w	= max columns
;	.__console_h	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display


        SECTION code_clib
	PUBLIC	ansi_CHAR

	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN	__console_w

; Dirty thing for self modifying code
	PUBLIC	INVRS	
	PUBLIC	BOLD
	PUBLIC	UNDERLINE

	SECTION	code_crt_init
	ld	a,64
	ld	(__console_w),a
	SECTION	code_clib


.ansi_CHAR
	ld (char+1),a
	ld a,(__console_y)       ; Line text position
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

	ld a,(__console_x)
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
	ld l,'A'      ; Put here the character to be printed
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl

IF ROMFONT
	ld de,15360
ELSE
	ld de,font-256
ENDIF
	add hl,de

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
