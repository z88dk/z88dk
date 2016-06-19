;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: sos_ropen.asm,v 1.3 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC sos_ropen
PUBLIC _sos_ropen

sos_ropen:
_sos_ropen:
	call $2009
	ld	hl,0
	ret	c
	inc	hl
	ret
