;
; 	ANSI Video handling for the Sharp OZ family
;	Stefano Bodrato - Nov. 2002
;
;	$Id: f_ansi_char.asm,v 1.4 2016-07-07 06:02:38 stefano Exp $
;
; 	Handles Attributes INVERSE + UNDERLINED
;
;	** alternate (smaller) 4bit font capability: 
;	** use the "ansifont_is_packed" flag
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;	.DOTS+1		= char size
;	.font		= font file
;

	SECTION	code_clib
; The font
; 8 dots: MAX 29 columns
; 7 dots: MAX 34 columns
; 6 dots: MAX 39 columns
; 5 dots: MAX 47 columns
; 4 dots: MAX 59 columns
; 3 dots: Almost 80 columns (79..+ 2 pixels)

;	defc columns	= 59
	
	defc row_bytes  = 30


;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;

	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x
	
	EXTERN	base_graphics
	
	EXTERN  swapgfxbk
	EXTERN	swapgfxbk1

	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	EXTERN	ansifont

	
; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

.ansi_CHAR

  	ld (char+1),a

  	ld	hl,(base_graphics)

	ld	a,(__console_y)

	and	a
	jr	z,ZROW
	add	a,a
	add	a,a
	add	a,a
	ld	b,a		; b=a*8  (8 is the font height)
	ld	de,row_bytes	; bytes per row
.Rloop
	add	hl,de
	djnz	Rloop
.ZROW

	call	swapgfxbk


  ld (RIGA+1),hl		; RIGA+1=ROW Location
  ld hl,DOTS+1
  ld b,(hl)				; b=DOTS

  ld hl,0

  ld a,(__console_x)    ; Column text position
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
.RIGA
  ld de,0				; ROW  Location on screen
  add hl,de
  push hl
  pop ix

.char
  ld b,'A'				; Put here the character to be printed

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

  ld de,8

.LFONT
  add hl,de
  djnz LFONT

  ld de,row_bytes			; ROW Lenght (in bytes)
  
  ld c,8
.PRE

  ld b,4
  rr (ix+1)
  rr (ix+0)
  inc b
  dec b
  jr z,DTS
.L1
  rr (ix+1)
  rr (ix+0)
  djnz L1
.DTS

  ld a,(hl)
.BOLD
  nop	;	rla
  nop	;	or (hl)
  ld b,a
  ld a,ansifont_is_packed
  and  a
  ld a,b
  jr   z,INVRS
 
.ROLL
  jr INVRS
  rla
  rla
  rla
  rla

; --- --- Inverse text handling
.INVRS
;  cpl					; Set to NOP to disable INVERSE
  nop
; --- ---

; --- --- Underlined text handling
  dec c
;  jr nz,UNDRL			; Set to JR UNDRL to disable underlined text (loc. INVRS+2)
  jr UNDRL
  ld a,255
.UNDRL
  inc c
; --- --- end of underlined text handling

.DOTS
  ld b,ansicharacter_pixelwidth

.L2
  rla
  ;rl (ix+1)
  ;rl (ix+0)
  rr (ix+1)
  rr (ix+0)
  djnz L2
.POST
  ld b,6
  inc b
  dec b
  jr z,NEXT
.L3
  ;rl (ix+1)
  ;rl (ix+0)
  rr (ix+1)
  rr (ix+0)
  djnz L3

.NEXT
  add ix,de
  inc hl
  dec c
  jr nz,PRE

	jp swapgfxbk1
  ;ret					;return


