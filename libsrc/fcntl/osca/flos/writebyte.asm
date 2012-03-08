;
; Placeholder for writebyte
;
; Stefano - 2/3/2005
;
; $Id: writebyte.asm,v 1.1 2012-03-08 07:16:46 stefano Exp $

	XLIB	writebyte

.writebyte
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
