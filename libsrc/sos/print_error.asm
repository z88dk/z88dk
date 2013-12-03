;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
; int print_error(code)
;
;       $Id: print_error.asm,v 1.1 2013-12-03 13:42:32 stefano Exp $
;

XLIB print_error

print_error:
	ld	a,l
   
   jp $2033
