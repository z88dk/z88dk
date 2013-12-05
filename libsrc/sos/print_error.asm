;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
; int print_error(code)
;
;       $Id: print_error.asm,v 1.2 2013-12-05 09:34:01 stefano Exp $
;

XLIB print_error

print_error:
	ld	a,l
   
   jp $2033
