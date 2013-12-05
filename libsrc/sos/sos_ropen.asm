;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_ropen.asm,v 1.1 2013-12-05 09:34:01 stefano Exp $
;


XLIB sos_ropen

sos_ropen:
	call $2009
	ld	hl,0
	ret	c
	inc	hl
	ret
