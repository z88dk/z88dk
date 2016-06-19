;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_wopen.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC sos_wopen
PUBLIC _sos_wopen

sos_wopen:
_sos_wopen:
	call $1faf
	ld	hl,0
	ret	c
	inc	hl
	ret
