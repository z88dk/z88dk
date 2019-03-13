;
;	ZX IF1 & Microdrive functions
;
;	int if1_setname(char* name, int location);
;
;	Put a 10 characters file name at the specified location
;	Truncate or fill with blanks when necessary.
;	Return with the file name length
;
;	$Id: if1_setname.asm,v 1.4 2016-07-01 22:08:20 dom Exp $
;

		SECTION code_clib
		PUBLIC	if1_setname
		PUBLIC	_if1_setname
	
if1_setname:
_if1_setname:
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
