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

; The font
; 9 dots: MAX 28 columns
; 8 dots: MAX 32 columns
; 7 dots: MAX 36 columns
; 6 dots: MAX 42 columns
; 5 dots: MAX 51 columns
; 4 dots: MAX 64 columns
; 3 dots: MAX 85 columns Just readable!
; 2 dots: MAX 128 columns (almost useless)
; No file for ROM Font

;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm,v 1.14 2016-08-01 14:25:55 stefano Exp $
;

        SECTION code_clib
	PUBLIC	ansi_CHAR

IF ROMFONT
	EXTERN	asctozx81
ENDIF
	
	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	EXTERN	ansifont
	
	EXTERN	base_graphics

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	PUBLIC	text_cols
IF G007
	PUBLIC	text_rows
ENDIF
IF MTHRG
	PUBLIC	text_rows
ENDIF
	
; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

	EXTERN	ansicolumns
.text_cols   defb ansicolumns

IF G007
.text_rows   defb 23
ENDIF
IF MTHRG
.text_rows   defb 24
ENDIF

.ansi_CHAR
; --- TO USE ROM FONT WE NEED TO MAP TO THE ASCII CODES ---
IF ROMFONT
	ld	hl,char+1
	ld	(hl),a
	call	asctozx81
ENDIF
; --- END OF ROM FONT ADAPTER ---

  ld (char+1),a
  ld a,(ansi_ROW)       ; Line text position
  
IF G007
	ld  h,0
	ld  e,a
	add a
	add a
	add a		; *8
	ld  l,a
	ld  a,e
	add	hl,hl	; *16
	add h
	ld	h,a		; *272
	ld de,(base_graphics)
	add hl,de
	ld de,9
	add hl,de
ELSE
 IF MTHRG
	ld  h,a		; *256
	add a
	add a
	add a		; *8   -> * 264
	ld	l,a

	inc	hl
	inc	hl
	;ld		de,($407B)
	ld de,(base_graphics)
	add hl,de
 ELSE
 ;  ld	d,a
 ;  ld	e,0
  ld hl,(base_graphics)
  add h
  ld  h,a
 ;  add hl,de
 ENDIF
ENDIF
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
IF ARX816
  add hl,hl
  add hl,hl
  add hl,hl
ENDIF

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
  ld (POST+1),a
.RIGA           ; Location on screen
  ld de,16384
  add hl,de
  push hl
  pop ix
.char
  ld b,'A'      ; Put here the character to be printed

IF ROMFONT
  ld hl,$1e00
  xor	a
  add	b
  jr	z,NOLFONT
ELSE

	  ld a,ansifont_is_packed
	  ld	hl,ansifont	- 256
	  and	a
	  jr    z,got_font_location

	  xor	a
	  rr	b
	  jr	c,even
	  ld	a,4
	.even
	  ld	(ROLL+1),a
	  ld hl,ansifont - 128

	.got_font_location

ENDIF

  ld de,8
.LFONT
  add hl,de
  djnz LFONT
.NOLFONT

IF !ARX816
IF G007
  ld de,34	; next row
ELSE
IF MTHRG
  ld de,33	; next row
ELSE
  ld de,32	; next row
ENDIF
ENDIF
ENDIF

  ld c,8
.PRE
  ld b,4
IF ARX816
  rl (ix+8)
ELSE
  rl (ix+1)
ENDIF
  rl (ix+0)
  inc b
  dec b
  jr z,DTS
.L1
IF ARX816
  rl (ix+8)
ELSE
  rl (ix+1)
ENDIF
  rl (ix+0)
  djnz L1
.DTS
  ld a,(hl)

.BOLD
  nop	;	rla
  nop	;	or (hl)
  
IF ROMFONT
	; nothing here !
ELSE

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
ENDIF

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
IF ARX816
  rl (ix+8)
ELSE
  rl (ix+1)
ENDIF
  rl (ix+0)
  djnz L2
.POST
  ld b,6
  inc b
  dec b
  jr z,NEXT
.L3
IF ARX816
  rl (ix+8)
ELSE
  rl (ix+1)
ENDIF
  rl (ix+0)
  djnz L3
.NEXT
IF ARX816
  inc ix
ELSE
  add ix,de
ENDIF
  inc hl
  dec c
  jr nz,PRE
  ret


