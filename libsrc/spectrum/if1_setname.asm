;
;	ZX IF1 & Microdrive functions
;
;	int if1_setname(char* name, int location);
;
;	Put a 10 characters file name at the specified location
;	Truncate or fill with blanks when necessary.
;	Return with the file name length
;
;	$Id: if1_setname.asm,v 1.1 2004-10-08 12:33:24 stefano Exp $
;

		XLIB	if1_setname
	
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

		neg	a		;..now onto the trailing spaces
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
