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
;
;
;	$Id: f_ansi_char.asm,v 1.12 2016-06-13 22:07:53 dom Exp $
;

	SECTION	smc_clib
	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	EXTERN	__zx_console_attr

	PUBLIC	__console_w
	PUBLIC	__console_h
	
; Dirty thing for self modifying code
	PUBLIC	INVRS	

	EXTERN	ansicolumns
.__console_w   defb ansicolumns
.__console_h   defb 24

	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	EXTERN	ansifont

ansi_CHAR:
	ld	b,a		;save character
	ld	a,ansicharacter_pixelwidth
	cp	8
	ld	a,b
	jr	nz,ansi_CHAR_flexible
; So we can fast path 32 column printing
	ex	af,af		;save character
	ld	a,(__console_x)
	ld	l,a
	ld	a,(__console_y)
	ld	h,a
	rrca
	rrca
	rrca
	and	0xe0
	or	l
	ld	e,a
	ld	a,h
	and	0x18
	or	0x40
	ld	d,a		;hl = screen address

	ex	af,af		;a = character to print
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	bc,ansifont-256
	add	hl,bc		;hl = bitmap to print

	ld	b,7
	ld	a,(INVRS)
	ld	c,a
char_loop:
	ld	a,(hl)
	bit	0,c
	jr	z,no_invers
	cpl
no_invers:
	ld	(de),a
	inc	hl
	inc	d
	djnz 	char_loop
; Now check for underline
	ld	c,(hl)		;next row to print
	ld	a,(INVRS+2)
	cp	24		;some magic change i think
	jr	z,no_underline
	ld	c,255
no_underline:
	ld	a,c
	ld	(de),a

; Now convert display address into attribute
	ld	a,d
	rra	
	rra
	rra
	and	3
	or	0x58
	ld	d,a
  	ld	a,(__zx_console_attr)  ;Current color attributes
	ld	(de),a
	ret
; End of fast path for 32 columns

.ansi_CHAR_flexible
  ld (char+1),a
  ld a,(__console_y)       ; Line text position
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
  ld a,(__console_x)       ; Column text position
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
.ZCL
; Added for color handling
  push hl
  push af
  ld de,22528-32
  add hl,de
  ld a,(__console_y)
  inc a
  ld de,32
.CLP
  add hl,de
  dec a
  jr nz,CLP
  ld a,(__zx_console_attr)  ;Current color attributes
  ld (hl),a
  pop af
  pop hl
; end of color handling

  ld b,5
.RGTA
  srl a
  djnz RGTA
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
  ld a,ansifont_is_packed
  ld	hl,ansifont - 256
  and	a
  jr    z,got_font_location
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
  ld a,ansifont_is_packed
  and  a
  ld a,(hl)
  jr   z,INVRS
.ROLL
	jr INVRS
	  rla
	  rla
	  rla
	  rla

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
  ld b,ansicharacter_pixelwidth

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

