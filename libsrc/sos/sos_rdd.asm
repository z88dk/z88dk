;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_rdd.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC sos_rdd

sos_rdd:
	call $1fa6
	ld	hl,0
	ret	c
	inc	hl
	ret
