;
;	ZX IF1 & Microdrive functions
;
;	char* if1_getname(char *location);
;
;	Picks a file name from the specified location
;	This one is still broken!!!
;
;	$Id: if1_getname.asm,v 1.1 2004-10-08 12:33:24 stefano Exp $
;

		XLIB	if1_getname

tempmdvname: defs 11

if1_getname:
		pop	bc	; ret addr
		pop	hl	; location
		push	hl
		push	bc
		
		ld	de,tempmdvname
		push	de
		ld	bc,10
		ldir

previous:	ld	hl,tempmdvname+11
		dec	hl
		ld	a,(hl)
		cp	' '
		jr	z,previous
		inc	hl
		ld	(hl),0
		
		pop	hl	; pointer to temp name
		ret
