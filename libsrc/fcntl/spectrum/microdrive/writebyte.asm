;
; Placeholder for writebyte
;
; Stefano - 2/3/2005
;
; $Id: writebyte.asm,v 1.3 2016-06-23 20:42:35 dom Exp $

	SECTION code_clib
	PUBLIC	writebyte
	PUBLIC	_writebyte

.writebyte
._writebyte
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
