;
;	Jupiter ACE specific routines
;	by Stefano Bodrato, 31/05/2010
;
;	unsigned int ace_freemem();
;
;	This function returns the free memory size
;
;	$Id: ace_freemem.asm,v 1.2 2015-01-19 01:32:41 pauloscustodio Exp $
;

	PUBLIC	ace_freemem
	
ace_freemem:
	ld	hl,($3C3B)	; Spare
	ret
