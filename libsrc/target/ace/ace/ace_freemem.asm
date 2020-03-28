;
;	Jupiter ACE specific routines
;	by Stefano Bodrato, 31/05/2010
;
;	unsigned int ace_freemem();
;
;	This function returns the free memory size
;
;	$Id: ace_freemem.asm,v 1.3 2016-06-10 22:57:07 dom Exp $
;

	SECTION code_clib
	PUBLIC	ace_freemem
	PUBLIC	_ace_freemem
	
ace_freemem:
_ace_freemem:
	ld	hl,($3C3B)	; Spare
	ret
