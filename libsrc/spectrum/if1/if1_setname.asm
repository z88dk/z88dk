;
;	ZX IF1 & Microdrive functions
;
;	int if1_setname(char* name, int location);
;
;	Put a 10 characters file name at the specified location
;	Truncate or fill with blanks when necessary.
;	Return with the file name length
;
;	$Id: if1_setname.asm,v 1.3 2015-01-19 01:33:10 pauloscustodio Exp $
;

		PUBLIC	if1_setname
	
if1_setname:
		pop	bc	; ret addr
		pop	hl	; location
		pop	de	; name
		push	de
		push	hl
		push	bc

		xor	a
strcpylp:
		push	af
		ld	a,(de)
		and	a		; check for string termination
		jr	z,strcopied
		ld	(hl),a
		inc	hl
		inc	de
		pop	af
		inc	a
		cp	10		; max filename size
		jr	z,scopied2
		jr	strcpylp
strcopied:	pop	af
scopied2:	push	af		; filename length

		neg			;..now onto the trailing spaces
		add	10
		ld	b,a		
		jr	z,nospaces
		ld	b,a
		ld	a,' '
spcloop:
		ld	(hl),a
		inc	hl
		djnz	spcloop
nospaces:

		pop	af
		ld	h,0
		ld	l,a
		ret
