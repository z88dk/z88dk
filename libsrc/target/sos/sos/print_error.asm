;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
; int print_error(code)
;
;       $Id: print_error.asm,v 1.4 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC print_error
PUBLIC _print_error

print_error:
_print_error:
	ld	a,l
   	jp $2033
