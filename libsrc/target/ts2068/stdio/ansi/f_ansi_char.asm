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
;	$Id: f_ansi_char.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib

IF A64COL
	INCLUDE "target/ts2068/stdio/ansi/f_ansi_char64.asm"
ELSE

IF A80COL
	INCLUDE "target/ts2068/stdio/ansi/f_ansi_char85.asm"
ELSE

IF A85COL
	INCLUDE "target/ts2068/stdio/ansi/f_ansi_char85.asm"
ELSE

	PUBLIC	ansi_CHAR
	
	EXTERN	__console_y
	EXTERN	__console_x

	PUBLIC	__console_w
	PUBLIC	__console_h
	
; Dirty thing for self modifying code
	PUBLIC	INVRS	
	PUBLIC	BOLD

	SECTION code_crt_init
	EXTERN	__console_w
IF A255COL
	ld	a,255
	ld	(__console_w),a
ENDIF

IF A160COL
	ld	a,160
	ld	(__console_w),a
ENDIF

IF A170COL
	ld	a,170
	ld	(__console_w),a
ENDIF

IF A128COL
	ld	a,128
	ld	(__console_w),a
ENDIF

IF A102COL
	ld	a,102
	ld	(__console_w),a
ENDIF

IF A85COL
	ld	a,85
	ld	(__console_w),a
ENDIF

IF A80COL
	ld	a,80
	ld	(__console_w),a
ENDIF

IF A73COL
	ld	a,73
	ld	(__console_w),a
ENDIF

IF A64COL
	ld	a,64
	ld	(__console_w),a
ENDIF

IF A56COL
	ld	a,56
	ld	(__console_w),a
ENDIF
	SECTION	code_clib


.ansi_CHAR
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
  ld a,l
  and 7
  ld b,3
.LDIV
  srl h
  rr l
  ;rra
  djnz LDIV
  srl l
  jr nc,ZCL
  set 5,h
.ZCL
; Added for color handling
;  push hl
 ; push af
;  ld de,22528-32
;  add hl,de
;  ld a,(__console_y)
;  inc a
;  ld de,32
;.CLP
;  add hl,de
;  dec a
;  jr nz,CLP
;  ld a,(23693)  ;Current color attributes
;  ld (hl),a
;  pop af
;  pop hl
; end of color handling

;  ld b,5
;.RGTA
;  srl a
;  djnz RGTA
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
  ld hl,15360
ELSE
	IF PACKEDFONT
	  xor	a
	  rr	b
	  jr	c,even
	  ld	a,4
	.even
	  ld	(ROLL+1),a
	  ld	hl,font-128
	ELSE
	  ld hl,font-256
	ENDIF
ENDIF

  ld de,8

.LFONT
  add hl,de
  djnz LFONT
  ld de,256
  ld c,8
.PRE
  ld b,4
  call rlix
  ;rl (ix+1)
  ;rl (ix+0)
  inc b
  dec b
  jr z,DTS
.L1
  call rlix
  ;rl (ix+1)
  ;rl (ix+0)
  djnz L1
.DTS
  ld a,(hl)

.BOLD
  nop	;	rla
  nop	;	or (hl)
  
IF ROMFONT
	; nothing here !
ELSE
	IF PACKEDFONT
	.ROLL
	  jr INVRS
	  rla
	  rla
	  rla
	  rla
	ENDIF
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
IF A256COL
  ld b,2
ENDIF
IF A160COL
  ld b,3
ENDIF
IF A170COL
  ld b,3
ENDIF
IF A128COL
  ld b,4
ENDIF
IF A102COL
  ld b,5
ENDIF
IF A85COL
  ld b,6
ENDIF
IF A80COL
  ld b,6
ENDIF
IF A73COL
  ld b,7
ENDIF
IF A64COL
  ld b,8
ENDIF
IF A56COL
  ld b,9
ENDIF

.L2
  rla
  call rlix
  ;rl (ix+1)
  ;rl (ix+0)
  djnz L2
.POST
  ld b,6
  inc b
  dec b
  jr z,NEXT
.L3
  call rlix
  ;rl (ix+1)
  ;rl (ix+0)
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
IF ROMFONT
	; nothing here !
ELSE
	IF PACKEDFONT
	        BINARY  "stdio/ansi/F4PACK.BIN"
	ELSE
		IF A256COL
			BINARY  "stdio/ansi/F3.BIN"
		ENDIF
		IF A160COL
			BINARY  "stdio/ansi/F4.BIN"
		ENDIF
		IF A170COL
			BINARY  "stdio/ansi/F4.BIN"
		ENDIF
		IF A128COL
			BINARY  "stdio/ansi/F4.BIN"
		ENDIF
		IF A102COL
			BINARY  "stdio/ansi/F5.BIN"
		ENDIF
		IF A85COL
			BINARY  "stdio/ansi/F6.BIN"
		ENDIF
		IF A80COL
			BINARY  "stdio/ansi/F6.BIN"
		ENDIF
		IF A73COL
			BINARY  "stdio/ansi/F8.BIN"
		ENDIF
		IF A64COL
			BINARY  "stdio/ansi/F8.BIN"
		ENDIF
		IF A56COL
			BINARY  "stdio/ansi/F8.BIN"
		ENDIF
	ENDIF
ENDIF

.rlix
    push bc
    ld b,ixh
    bit 5,b
    jr	z,first
    res 5,b
    ld ixh,b
    rl (ix+1)
    set 5,b
    ld ixh,b
    rl (ix+0)
    pop bc
    ret
.first
    set 5,b
    ld ixh,b
    rl (ix+0)
    res 5,b
    ld ixh,b
    rl (ix+0)
    pop bc
    ret
ENDIF
ENDIF
ENDIF
