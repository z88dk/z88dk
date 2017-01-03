;
;	ZX IF1 & Microdrive functions
;
;	char* if1_getname(char *location);
;
;	Picks a file name from the specified location
;
;	$Id: if1_getname.asm,v 1.4 2017-01-03 01:40:06 aralbrec Exp $
;

		SECTION code_clib
		PUBLIC	if1_getname
      PUBLIC   _if1_getname


if1_getname:
_if1_getname:
		pop	bc	; ret addr
		pop	hl	; location
		push	hl
		push	bc
		
		ld	de,tempmdvname
		push	de
		ld	bc,10
		ldir

		push	de
		pop	hl
		
previous:	dec	hl
		ld	a,(hl)
		cp	' '
		jr	z,previous
		inc	hl
		ld	(hl),0
		
		pop	hl	; pointer to temp name
		ret

		SECTION bss_clib
tempmdvname: defs 11
