;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_wrd.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC sos_wrd
PUBLIC _sos_wrd

sos_wrd:
_sos_wrd:
	call $1fac
	ld	hl,0
	ret	c
	inc	hl
	ret
