
;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;	Define User Defined Graphics character, valid codes:  E0h..FFh
;
;	$Id: px8_break.asm $
;
;
;


	SECTION	code_clib
	PUBLIC	px8_break
	PUBLIC	_px8_break
	PUBLIC	px8_stop
	PUBLIC	_px8_stop

	EXTERN subcpu_call

px8_stop:
_px8_stop:
	ld	hl,1
	jr	no_stop
	
px8_break:
_px8_break:
	ld	hl,0
no_stop:
	
	push hl
	ld	hl,(1)			; Use WBOOT address to find the first entry in the BIOS jp table
	
	ld	bc,$f10a
	ld	a,$eb			; Overseas version ?  ( HC-80 should be $E7, HC-88 is probably $C1)
	cp	h
	jr	z,european
	ld	bc,$ee24
.european
	pop hl
	add hl,bc
	xor a
	or (hl)
	
	ld	hl,0
	ret	z
	inc	hl
	ret
