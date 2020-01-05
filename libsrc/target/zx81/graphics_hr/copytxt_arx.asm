;
;	ZX81 libraries
;
;--------------------------------------------------------------
; This code comes from the 'HRG_Tool' 
; by Matthias Swatosch
; Original function name: "HRG_Tool_TXTcopy"
;--------------------------------------------------------------
;
;	$Id: copytxt_arx.asm,v 1.5 2017-01-02 22:58:00 aralbrec Exp $
;
;----------------------------------------------------------------
;
; HRG_Tool_TXTcopy
; hl = pointer to display array
;
; copies the textscreen (DFILE) into HRG
;
;----------------------------------------------------------------

	SECTION smc_clib
	PUBLIC	copytxt
   PUBLIC   copytxt

	EXTERN	base_graphics

copytxt:
_copytxt:
	ld	(ovmode),hl
	
	ld	hl,(base_graphics)

	ld	de,($400C)	; D_FILE

	inc	de
IF FORzx81hrg64
	ld	b,8
ELSE
	ld	b,24
ENDIF
	ld	c,0
	
HRG_TXTcopyLoop:
	ld	a,(de)
	or	a
	jr	z,HRG_TXTcopyNextChar

	cp	118
	jr	z,HRG_TXTcopyNextLine

	push	hl		; HL points to byte in HRG

	push	de		; A is character
	push	bc
	

	cp	$40		; inverse?
	push	af
	
	ld	de,$1e00	; start of characters in ROM
	ld	b,0

	and	$3f

	ld	c,a
	or	a

	rl	c		; multiply BC by 8
	rl	b
	rl	c
	rl	b
	rl	c
	rl	b
	ex	de,hl

	add	hl,bc

	ex	de,hl		; now DE is pointer to pixel code

		
	ld	c,$00		; C stores invers character information
	pop	af		; inverse?

	jr	c,HRG_TXTcopyNormal
	dec	c		; if inverse character then C is $ff
HRG_TXTcopyNormal:
	ld	b,8		; counter
HRG_TXTcopyLoop2:	
	ld	a,(de)
	xor	c

ovmode:	nop
	nop
	;or	(hl)		; plot the character to HRG
	ld	(hl),a

;	push	bc
;	ld	bc,32
;	add	hl,bc
;	pop	bc

	inc hl

	inc	de

	djnz	HRG_TXTcopyLoop2
	
	pop	bc
	pop	de
	pop	hl

HRG_TXTcopyNextChar:
	inc	de
	push	bc
	ld	bc,8
	add	hl,bc
	pop	bc
	;inc	hl
	jr	HRG_TXTcopyLoop


HRG_TXTcopyNextLine:
	inc	c
	inc	de
	ld	hl,(base_graphics)

	push	bc
	ld	b,c
	ld	c,0
	add	hl,bc
	pop	bc

	djnz	HRG_TXTcopyLoop
	ret
