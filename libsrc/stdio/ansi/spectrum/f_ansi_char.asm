;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
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
;	$Id: f_ansi_char.asm,v 1.3 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_CHAR
	
	XREF	ansi_ROW
	XREF	ansi_COLUMN

	XDEF	text_cols
	XDEF	text_rows
	
; Dirty thing for self modifying code
	XDEF	INVRS	

.text_cols   defb 51
.text_rows   defb 24

.ansi_CHAR
  ld (char+1),a
  ld a,(ansi_ROW)       ; Line text position
  push af
  and 24
  ld d,a
  pop af
  and 7
  rrca
  rrca
  rrca
  ld e,a
  ld hl,16384
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
  ld b,3
.LDIV
  srl h
  rr l
  rra
  djnz LDIV

; Added for color handling
  push hl
  push af
  ld de,22528-32
  add hl,de
  ld a,(ansi_ROW)
  inc a
  ld de,32
.CLP
  add hl,de
  dec a
  jr nz,CLP
  ld a,(23693)  ;Current color attributes
  ld (hl),a
  pop af
  pop hl
; end of color handling

  ld b,5
.RGTA
  srl a
  djnz RGTA
.ZCL
  ld (PRE+1),a
  ld e,a
  ld a,(DOTS+1)
  add a,e
  ld e,a
  ld a,16
  sub e
.NOC
  ld (POST+1),a
.RIGA           ; Location on screen
  ld de,16384
  add hl,de
  push hl
  pop ix
.char
  ld b,'A'      ; Put here the character to be printed
  ld de,8

  ;ld hl,font-256   ; Put here the character font location
  ; I'll probably strip the first 256 bytes, in future.
 ;ld hl,15360 ; The ROM font

  ld hl,font

.LFONT
  add hl,de
  djnz LFONT
  ld de,256
  ld c,8
.PRE
  ld b,4
  rl (ix+1)
  rl (ix+0)
  inc b
  dec b
  jr z,DTS
.L1
  rl (ix+1)
  rl (ix+0)
  djnz L1
.DTS
  ld a,(hl)
.INVRS
;  cpl           ; Set to NOP to disable INVERSE
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
  ld b,5        ; character FONT width in pixel
.L2
  rla
  rl (ix+1)
  rl (ix+0)
  djnz L2
.POST
  ld b,6
  inc b
  dec b
  jr z,NEXT
.L3
  rl (ix+1)
  rl (ix+0)
  djnz L3
.NEXT
  add ix,de
  inc hl
  dec c
  jr nz,PRE
  ret


; The font
; 9 dots: MAX 28 columns
; 8 dots: MAX 32 columns The only one perfecly color aligned
; 7 dots: MAX 36 columns
; 6 dots: MAX 42 columns Good matching with color attributes
; 5 dots: MAX 51 columns
; 4 dots: MAX 64 columns Matched with color attributes (2 by 2)
; 3 dots: MAX 85 columns Just readable!
; 2 dots: MAX 128 columns (useful for ANSI graphics only.. maybe)
; Address 15360 for ROM Font


.font
        BINARY  "stdio/ansi/spectrum/FONT5.BIN"

