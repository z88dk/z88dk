;
;	Jupiter ACE specific routines
;	by Stefano Bodrato, 31/05/2010
;
;	unsigned int ace_freemem();
;
;	This function returns the free memory size
;
;	$Id: ace_freemem.asm,v 1.1 2010-05-31 08:29:06 stefano Exp $
;

	XLIB	ace_freemem
	
ace_freemem:
	ld	hl,($3C3B)	; Spare
	ret
