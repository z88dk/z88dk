;
; 	ANSI Video handling for the CCE MC-1000 (in ZX Spectrum style)
;
;	** alternate (smaller) 4bit font capability: 
;	** use the -DPACKEDFONT flag
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
;	$Id: f_ansi_char.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_driver
	
	PUBLIC	ansi_CHAR

	;EXTERN	base_graphics
	EXTERN	pix_return

	EXTERN	__console_y
	EXTERN	__console_x

; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

        EXTERN  ansicharacter_pixelwidth
        EXTERN  ansifont_is_packed
        EXTERN  ansifont

.ansi_CHAR

	ld	b,a		;save character
	ld	a,ansicharacter_pixelwidth
	cp	8
	ld	a,b
	jr	nz,ansi_CHAR_flexible

	
	
; So we can fast path 32 column printing
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl		
	ld	de,ansifont	- 256
	add	hl,de
	ld a,(__console_y)       ; Line text position
	add	$80
	ld d,a
	ld a,(__console_x)       ; Column text position
	ld e,a

	ld c,8
.floop
	ld	a,(hl)
	call char_attribute
	cpl
	call	pix_return
	inc hl
	ld	a,32
	add	e
	ld	e,a
	jr nc,nocy
	inc d
.nocy
	dec c
	jr nz,floop
	ret
	
	
.ansi_CHAR_flexible
  ld (char+1),a
  ld a,(__console_y)       ; Line text position
  
  ld	d,a
  ld	e,0
  
  ld hl,$8000
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
  ;cpl
  call char_attribute


.DOTS
  ld b,ansicharacter_pixelwidth

  call pix_rl

  add ix,de
  inc hl
  dec c
  jr nz,PRE
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.char_attribute
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

.INVRS
  cpl           ; Set to CPL to disable INVERSE
;  nop

; Underlined text handling
  dec c
;  jr nz,UNDRL   ; Set to JR UNDRL to disable underlined text (loc. INVRS+2)
  jr UNDRL
  cpl
.UNDRL
  inc c
; end of underlined text handling
  ret


;------- ANSI VT support (chunk 1)
.pix_pre
	ld	a,$9e
	out	($80),a

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
	;ex	af,af	;
	ld	a,$9f
	out	($80),a
	;ex	af,af	;
	ret

;------- ANSI VT support (chunk 2)
.pix_rl
	ex	af,af	;
	ld	a,$9e
	out	($80),a
	ex	af,af	;
.L2
	rla
	rl (ix+1)
	rl (ix+0)
	djnz L2
.pix_post
	ld b,6
	inc b
	dec b
	jr z,NEXT
.L3
	rl (ix+1)
	rl (ix+0)
	djnz L3
.NEXT
	ld	a,$9f
	out	($80),a	
	ret
