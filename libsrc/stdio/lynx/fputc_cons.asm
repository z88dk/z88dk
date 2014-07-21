;
;       Camputers Lynx C Library
;
;	Print character to the screen
;
;       Stefano Bodrato - 2014
;
;
;	$Id: fputc_cons.asm,v 1.1 2014-07-21 12:39:53 stefano Exp $
;


          XLIB  fputc_cons


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	;cp	12
	;jp  z,$8e5  ; CLS

.setout
	rst 8
	ret

