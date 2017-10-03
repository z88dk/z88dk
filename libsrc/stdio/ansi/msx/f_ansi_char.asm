;
; 	ANSI Video handling for the MSX/SVI video chip
;
;	set it up with:
;	.text_cols	= max columns
;	.text_rows	= max rows
;
;	Display a char in location (ansi_ROW),(ansi_COLUMN)
;	A=char to display
;
;
;	Stefano Bodrato - Oct. 2017
;

	SECTION	smc_clib
	
	PUBLIC	ansi_CHAR

	EXTERN	msx_attr
	
	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	EXTERN	ansifont
	
	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	EXTERN     swapgfxbk
        EXTERN	__graphics_end

	INCLUDE	"msx/vdp.inc"

	PUBLIC	text_cols
	PUBLIC	text_rows
	
; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

	EXTERN	ansicolumns
.text_cols   defb ansicolumns

.text_rows   defb 24


.ansi_CHAR

	push ix
	ld ix,chline_buffer
	call swapgfxbk

  ld (char+1),a
  
  ld a,(ansi_ROW)       ; Line text position
   
	ld	h,a		; current row * 256 = start position in VRAM
	ld  l,0
	ld (RIGA+1),hl

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


;**************
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
	ld (chline_buffer),a

	ld de,32	; next row
	add hl,de
	
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
	ld (chline_buffer+1),a
;**************
	
  
.char
  ld b,'A'      ; Put here the character to be printed

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
.NOLFONT

  ;ld de,32	; next row

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
	push hl		; save font ptr
	push bc		; save font counter
	
	ld hl,(RIGA+1)
	push hl
;**************
         ld       a,l		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,h		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(chline_buffer)
         out      (VDP_DATA), a

	ld de,32	; next row
	add hl,de
		 
         ld       a,l		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,h		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(chline_buffer+1)
         out      (VDP_DATA), a
		 
	ld de,8192-32	; next row
	add hl,de
		 
         ld       a,l		; LSB of video memory ptr
         out      (VDP_CMD),a
         ld       a,h		; MSB of video mem ptr
         and      @00111111	; masked with "write command" bits
         or       @01000000
         out      (VDP_CMD), a
         ld       a,(msx_attr)
         out      (VDP_DATA), a
;**************
	pop hl
	inc hl
	
	ld (RIGA+1),hl

;**************
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
	ld (chline_buffer),a

	ld de,32	; next row
	add hl,de
	
	ld	a,l		; LSB of video memory ptr
	out	(VDP_CMD), a
	ld	a,h		; MSB of video mem ptr
	and	@00111111	; masked with "read command" bits
	out	(VDP_CMD), a
	in	a, (VDP_DATAIN)
	ld (chline_buffer+1),a
;**************

	pop bc		; restore font counter
	pop hl		; restore font ptr
  ;add ix,de
  inc hl
  dec c
  jp nz,PRE
  jp __graphics_end


	SECTION bss_clib
	
.chline_buffer
	defs 2
