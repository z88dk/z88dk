;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_ropen.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;


PUBLIC sos_ropen

sos_ropen:
	call $2009
	ld	hl,0
	ret	c
	inc	hl
	ret
