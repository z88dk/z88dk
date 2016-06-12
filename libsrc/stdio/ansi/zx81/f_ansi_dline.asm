;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX 81
;
; 	Clean a text line
;
;	Stefano Bodrato - Sept. 2007
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.7 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_del_line
	EXTERN	base_graphics


.ansi_del_line
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
	ld	de,(base_graphics)
ELSE
 IF MTHRG
	ld  h,a		; *256
	add a
	add a
	add a		; *8   -> * 264
	ld	l,a
;	inc	hl
;	inc	hl
	;ld		de,($407B)
	ld de,(base_graphics)
 ELSE
	ld	d,a
	ld	e,0
	ld	hl,(base_graphics)
 ENDIF
ENDIF
	add	hl,de	;Line address in HL
	
IF MTHRG

	ld	a,8
.floop
	ld (hl),$76
	inc hl
	ld b,32
.zloop
	ld (hl),0
	inc hl
	djnz zloop
	dec a
	jr nz,floop

ELSE

	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
IF G007
	ld	bc,271
ELSE
	ld	bc,255
ENDIF
	ldir

	ENDIF
	ret
