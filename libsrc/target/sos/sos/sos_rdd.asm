;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_rdd.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC sos_rdd
PUBLIC _sos_rdd

sos_rdd:
_sos_rdd:
	call $1fa6
	ld	hl,0
	ret	c
	inc	hl
	ret
