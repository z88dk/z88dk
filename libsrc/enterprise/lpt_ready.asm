;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, March 2011
;
;	int lpt_ready();
;
;	Check if the line printer is ready (1=ready, 0 if not)
;
;	$Id: lpt_ready.asm,v 1.1 2011-03-19 14:32:51 stefano Exp $
;

	XLIB	lpt_ready
	
lpt_ready:
	in	a,($b5)
	bit	3,a
	ld	hl,0
	ret	nz
	inc	l
	ret
