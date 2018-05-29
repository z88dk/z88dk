;
; 	ANSI Video handling for the MSX/SVI video chip
;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
;
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	Stefano Bodrato - Oct. 2017
;

	SECTION	smc_clib
	
	PUBLIC	ansi_CHAR

	EXTERN	msxbios
	
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
	EXTERN	FILVRM
	EXTERN	LDIRVM
ENDIF


	EXTERN	msx_attr
	
	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	EXTERN	ansifont
	
	EXTERN	__console_y
	EXTERN	__console_x

	EXTERN     swapgfxbk
        EXTERN	__graphics_end

	INCLUDE	"msx/vdp.inc"

; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

	EXTERN	ansicharacter_pixelwidth


.ansi_CHAR

	push ix
	call swapgfxbk
	
	ld	b,a		;save character
	ld	a,ansicharacter_pixelwidth
	cp	8
	ld	a,b
	jr	nz,ansi_CHAR_flexible
	
; So we can fast path 32 column printing
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	de,ansifont - 256
	add	hl,de
	ld	bc,8
	ld	a,(__console_x)
	add	a
	add	a
	add	a
	ld	e,a
	ld	a,(__console_y)
	ld	d,a
	ld	ix,LDIRVM
	push	de
	call	msxbios
	pop	de
	jp	set_attribute
	
	

.ansi_CHAR_flexible
	ld	ix,chline_buffer
	ld	(char+1),a			;SMC
  	ld	a,(__console_y)       ; Line text position
	ld	h,a		; current row * 256 = start position in VRAM
	ld	l,0
	ld	(RIGA+1),hl

	ld	hl,DOTS+1
	ld	b,(hl)
	ld	hl,0
	ld	a,(__console_x)       ; Column text position
	ld	e,a
	ld	d,0
  	or	d
	jr	z,ZCL
.LP
	add	hl,de
	djnz	LP

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
  ld de,0		; Self Modifying Code
  add hl,hl
  add hl,hl
  add hl,hl
  add hl,de
  ld (RIGA+1),hl
  ld (RIGA2+1),hl


;**************
IF VDP_CMD > 255
	ld	a,l
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	ld	(VDP_CMD),a
	ld	a,(VDP_DATAIN)
ELSE
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
ENDIF
	ld (chline_buffer),a

	ld	de,8	; next row
	add	hl,de

IF VDP_CMD > 255
	ld	a,l
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	ld	(VDP_CMD),a
	ld	a,(VDP_DATAIN)
ELSE	
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
ENDIF
	ld (chline_buffer+1),a
;**************
	
  
.char
	ld	b,'A'      ; SMC Put here the character to be printed
	ld	a,ansifont_is_packed
	ld	de,ansifont	- 256
	and	a
	jr	z,got_font_location
	xor	a
	rr	b
	jr	c,even
	ld	a,4
.even
	ld	(ROLL+1),a
	ld	de,ansifont - 128
.got_font_location
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
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
	push hl		; save font ptr
	push bc		; save font counter
	
	ld hl,(RIGA+1)
	push hl
;**************
IF VDP_CMD > 255
	ld	a,l
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	or	@01000000
	ld	(VDP_CMD),a
	ld	a,(chline_buffer)
	ld	(VDP_DATA),a
ELSE
         ld       a,l		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,h		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(chline_buffer)
         out      (VDP_DATA), a
ENDIF

	ld de,8	; next row
	add hl,de

IF VDP_CMD > 255
	ld	a,l	
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	or	@01000000
	ld	(VDP_CMD),a
	ld	a,(chline_buffer+1)
	ld	(VDP_DATA),a
ELSE
		 
         ld       a,l		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,h		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(chline_buffer+1)
         out      (VDP_DATA), a
ENDIF
		 
;	ld de,8192-8	; attribute
;	add hl,de
		 
;         ld       a,l		; LSB of video memory ptr
;         out      (VDP_CMD),a
;         ld       a,h		; MSB of video mem ptr
;         and      @00111111	; masked with "write command" bits
;         or       @01000000
;         out      (VDP_CMD), a
;         ld       a,(msx_attr)
;         out      (VDP_DATA), a

;**************
	pop hl
	inc hl
	
	ld (RIGA+1),hl

;**************
IF VDP_CMD > 255
	ld	a,l
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	ld	(VDP_CMD),a
	ld	a,(VDP_DATAIN)
ELSE
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
ENDIF
	ld (chline_buffer),a

	ld de,8	; next row
	add hl,de

IF VDP_CMD > 255
	ld	a,l
	ld	(VDP_CMD),a
	ld	a,h
	and	@00111111
	ld	(VDP_CMD),a
	ld	a,(VDP_DATAIN)
ELSE	
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
ENDIF
	ld (chline_buffer+1),a
;**************

	pop bc		; restore font counter
	pop hl		; restore font ptr
  ;add ix,de
  inc hl
  dec c
  jp nz,PRE
  
.RIGA2
	ld	de,0		;SMC, screen location
.set_attribute
	ld	hl,8192
	add	hl,de
	ld	a,(msx_attr)
	ld	bc,8
	ld	ix,FILVRM
	call	msxbios
  	jp	__graphics_end


;	SECTION bss_clib
	
.chline_buffer
	defs 2
