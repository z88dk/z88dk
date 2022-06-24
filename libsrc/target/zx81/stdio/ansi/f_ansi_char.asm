;
; 	ANSI Video handling for the ZX81
;
;	** alternate (smaller) 4bit font option

;	** ROM font -DROMFONT, or uncomment the next line.
; defc ROMFONT=1
; .. to use the ROM font rebuild the libraries and add in your compilation command line the extra parameters:
;   -pragma-define:ansifont=0 -pragma-define:ansifont_is_packed=0 -pragma-define:ansicolumns=36

;
;	set it up with:
;	.__console_w	= max columns
;	.__console_h	= max rows
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
;	Display a char in location (__console_y),(__console_x)
;	A=char to display
;
;
;	$Id: f_ansi_char.asm $
;


        SECTION code_clib
	PUBLIC	ansi_CHAR

IF ROMFONT
	EXTERN	asctozx81
ELSE
	EXTERN	ansifont
ENDIF
	
	EXTERN	ansicharacter_pixelwidth
	EXTERN	ansifont_is_packed
	
	EXTERN	base_graphics

	EXTERN	__console_y
	EXTERN	__console_x

	
; Dirty thing for self modifying code
	PUBLIC	INVRS
	PUBLIC	BOLD

;IF G007
;	SECTION	code_crt_init
;	EXTERN	_console_h
;	ld	a,23
;	ld	(_console_h),a
;	SECTION	code_clib
;ENDIF


.ansi_CHAR
	ld	hl,char+1
; --- TO USE ROM FONT WE NEED TO MAP TO THE ASCII CODES ---
IF ROMFONT
	ld	e,a

	xor a
    ld	(UCASE),a
    ld	(UCASE+1),a
	ld	(UCASE+2),a
	ld	a,(BOLD)
	xor $17	; rla
	ld	(UCASE+3),a

	
;	ld	a,ansifont/256
;	cp $1F	; ROM font ?
	ld	a,e
;	jr	nz,norom
	ld	(hl),a
	call	asctozx81
	
		ld	e,a
		rla
		ld	a,e
		jr nc,noupr
        ld	a,$23	; inc hl
        ld	(UCASE),a
        ld	a,$b6	; or (hl)
        ld	(UCASE+1),a
        ld	a,$2b	; dec hl
        ld	(UCASE+2),a
;	xor a
;	ld	(UCASE+3),a
		ld	a,e
		and $7f
.noupr
ENDIF
; --- END OF ROM FONT ADAPTER ---
.norom
  ld (hl),a
  ld a,(__console_y)       ; Line text position
  
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
  ;ld hl,ansifont-256
  ld hl,$1E00
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

IF ROMFONT
.UCASE
  nop
  nop
  nop
  rla	; shift character left to squeeze it as much as possible (36..42 columns still usable)
ENDIF

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
  ld a,255	; ..a possible variant is CPL
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


