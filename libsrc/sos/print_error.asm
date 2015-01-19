;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
; int print_error(code)
;
;       $Id: print_error.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

PUBLIC print_error

print_error:
	ld	a,l
   
   jp $2033
