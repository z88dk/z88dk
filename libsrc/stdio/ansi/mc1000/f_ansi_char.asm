;
; 	ANSI Video handling for the CCE MC-1000 (in ZX Spectrum style)
;
;	** alternate (smaller) 4bit font capability: 
;	** use the -DPACKEDFONT flag
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR

	;EXTERN	base_graphics
	EXTERN	pix_rl
	EXTERN	pix_pre
	EXTERN	pix_post

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	PUBLIC	text_cols
	PUBLIC	text_rows
		
; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

        EXTERN  ansicharacter_pixelwidth
        EXTERN  ansifont_is_packed
        EXTERN  ansifont
        EXTERN  ansicolumns
.text_cols   defb ansicolumns
.text_rows   defb 24

.ansi_CHAR

  ld (char+1),a
  ld a,(ansi_ROW)       ; Line text position
  
  ld	d,a
  ld	e,0
  
  ld hl,$8000
  add hl,de
  ld (RIGA+1),hl
;  xor a
  ld hl,DOTS+1
  ld b,(hl)
  ld hl,0

  ld a,(ansi_COLUMN)       ; Column text position
  ld e,a
  ld d,0
  or d
  jr z,ZCL
.LP
  add hl,de
  djnz LP

  srl h
  rr l
  rra
  srl h
  rr l
  rra
  srl h
  rr l
  rra

  srl a
  srl a
  srl a
  srl a
  srl a
;  ld b,5
;.RGTA
;  srl a
;  djnz RGTA
.ZCL
  ld (PRE+1),a
  ld e,a
  ld a,(DOTS+1)
  add a,e
  ld e,a
  ld a,16
  sub e
.NOC
  ld (pix_post+1),a
.RIGA           ; Location on screen
  ld de,$8000
  add hl,de
  push hl
  pop ix
.char
  ld	b,'A'      ; Put here the character to be printed
  ld	hl,ansifont - 256
  ld	a,ansifont_is_packed
  and	a
  jr	z,got_font_location
  xor	a
  rr	b
  jr	c,even
  ld	a,4
.even
  ld	(ROLL+1),a
  ld	hl,ansifont-128
.got_font_location

  ld de,8
.LFONT
  add hl,de
  djnz LFONT
.NOLFONT

  ld de,32	; next row
  
  ld c,8
.PRE
  ld b,4
  call pix_pre

  ld a,(hl)

.BOLD
  nop	;	rla
  nop	;	or (hl)
  ld	b,a
  ld	a,ansifont_is_packed
  and   a
  ld    a,b
  jr    z,INVRS
.ROLL
  jr INVRS
  rla
  rla
  rla
  rla

.INVRS
  cpl           ; Set to CPL to disable INVERSE
  nop

; Underlined text handling
  dec c
;  jr nz,UNDRL   ; Set to JR UNDRL to disable underlined text (loc. INVRS+2)
  jr UNDRL
  ld a,255
.UNDRL
  inc c
; end of underlined text handling

.DOTS
  ld b,ansicharacter_pixelwidth

  call pix_rl

  add ix,de
  inc hl
  dec c
  jr nz,PRE
  ret


; The font
; 9 dots: MAX 28 columns
; 8 dots: MAX 32 columns
; 7 dots: MAX 36 columns
; 6 dots: MAX 42 columns
; 5 dots: MAX 51 columns
; 4 dots: MAX 64 columns
; 3 dots: MAX 85 columns Just readable!
; 2 dots: MAX 128 columns (useful for ANSI graphics only.. maybe)

