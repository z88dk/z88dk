;
;	PX-8 routines
;	by Stefano Bodrato, 2019
;
;	Internal use routine, SLVFLG must be set first.
;
;	$Id: subcpu_call.asm $
;
;
;	IN:  HL = packet descriptor
;


	SECTION	code_clib
	PUBLIC	subcpu_call
	PUBLIC	_subcpu_call
	
subcpu_call:
_subcpu_call:

	ex	de,hl			; 
	
	ld	hl,(1)			; Use WBOOT address to find the first entry in the BIOS jp table
	
	ld	bc,$f358
	ld	a,$eb			; Overseas version ?  ( HC-80 should be $E7, HC-88 is probably $C1)
	cp	h
	jr	z,european
	ld	bc,$f080
.european
	push bc
	ld	a,$ff		; SLVFLAG, enable all the communications with the slave CPU
	ld	(bc),a
	ld	a,$72			; slave BIOS call offset
	add	l
	ld	l,a
	ld	bc,retaddr
	push bc
	jp	(hl)
.retaddr
	pop hl
	ld	(hl),0		; restore SLVFLAG
	
	ld	l,a			; return status from the slave BIOS call
	ld	h,0
	
	ret

