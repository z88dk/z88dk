;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_wrd.asm,v 1.1 2013-12-05 09:34:01 stefano Exp $
;


XLIB sos_wrd

sos_wrd:
	call $1fac
	ld	hl,0
	ret	c
	inc	hl
	ret
