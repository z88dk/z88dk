;
;       Spectrum C Library
;
; 	ANSI Video handling for TS 2068 85 columns
;	** ROM font -DROMFONT
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;	.font		= font file
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char85.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	PUBLIC	text_cols
	PUBLIC	text_rows

; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD
	PUBLIC	UNDERLINE

IF A85COL
.text_cols   defb 85
ENDIF

IF A80COL
.text_cols   defb 80
ENDIF

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
	ld c,a
	add a,a
	add a,c
	srl a
	srl a
	srl a
	add a,l
	ld l,a
	push hl ; screen address

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

	ex de,hl; de - font
	pop hl ; screen

	ld a,c
	and 7
	jp z,jump0
	dec a
	jp z,jump1
	dec a
	jp z,jump2
	dec a
	jp z,jump3
	dec a
	jp z,jump4
	dec a
	jp z,jump5
	dec a
	jp z,jump6
;	jp jump7

.jump7; second display bits 5-0
	set 5,h
;	jr jump3

.jump3; first display bits 5-0
	ld b,8
.loop3
	call prepare
	rrca
	rrca
	and 63; 00111111
	ld c,a
	ld a,(hl)
	and 192
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop3

	ld c,63
	jr under

.jump4; second display bits 7-2
	set 5,h
;	jr jump0

.jump0; first display, bits 7-2
	ld b,8
.loop0
	call prepare
	and 252; 11111100
	ld c,a
	ld a,(hl)
	and 3
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop0

	ld c,252
	jr under


.jump1; first screen 1-0, second screen 7-4
	push de
	push hl
	ld b,8
.loop1a
	call prepare
	rlca
	rlca
	and 3; 00000011
	ld c,a
	ld a,(hl)
	and 252
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop1a

	ld c,3
	call under

	pop hl
	set 5,h
.preloop1b
	pop de
	ld b,8
.loop1b
	call prepare
	rlca
	rlca
	and 240; 11110000
	ld c,a
	ld a,(hl)
	and 15
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop1b

	ld c,240
	jr under

.jump5; second display bits 1-0, first display next 7-4
	push de
	push hl
	set 5,h
	ld b,8
.loop5a
	call prepare
	rlca
	rlca
	and 3; 00000011
	ld c,a
	ld a,(hl)
	and 252
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop5a

	ld c,3
	call under

	pop hl
	inc hl
	jr preloop1b

.under
	dec h
.UNDERLINE
	ld a,0 ; underline
	and c
	or (hl)
	ld (hl),a
	ret

.jump2; second display bits 3-0, first display next 7-6
	push de
	push hl
	set 5,h
	ld b,8
.loop2a
	call prepare
	rrca
	rrca
	rrca
	rrca
	and 15; 00001111
	ld c,a
	ld a,(hl)
	and 240
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop2a

	ld c,15
	call under

	pop hl
	inc hl
.preloop2b
	ld b,8
	pop de
.loop2b
	call prepare
	rrca
	rrca
	rrca
	rrca
	and 192; 11000000
	ld c,a
	ld a,(hl)
	and 63
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop2b

	ld c,192
	jr under

.jump6; first display bits 3-0; second display bits 7-6
	push de
	push hl
	ld b,8
.loop6a
	call prepare
	rrca
	rrca
	rrca
	rrca
	and 15; 00001111
	ld c,a
	ld a,(hl)
	and 240
	or c
	ld (hl),a
	inc h
	inc de
	djnz loop6a

	ld c,15
	call under

	pop hl
	set 5,h
	jr preloop2b

.prepare
	ex de,hl
	ld a,(hl)
.BOLD
	nop
	nop
.INVRS
	xor 0
	ex de,hl
	ret

.font
IF ROMFONT
	; nothing here !
ELSE
	BINARY  "stdio/ansi/F6.BIN"
ENDIF
