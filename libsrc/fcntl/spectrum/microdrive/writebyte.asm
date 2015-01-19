;
; Placeholder for writebyte
;
; Stefano - 2/3/2005
;
; $Id: writebyte.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	writebyte

.writebyte
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
