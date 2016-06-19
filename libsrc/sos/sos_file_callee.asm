;
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;	Set the current S-OS file name and type
;
;	; int sos_file(char *name,type)
;
;
;	$Id: sos_file_callee.asm,v 1.5 2016-06-19 20:58:00 dom Exp $
;

        SECTION   code_clib
PUBLIC	sos_file_callee
PUBLIC	_sos_file_callee
PUBLIC	ASMDISP_SOS_FILE_CALLEE


sos_file_callee:
_sos_file_callee:
	pop  bc
	pop  hl
	pop  de
	push  bc

; enter : dl = *name
;         l = type

.asmentry
;jr asmentry
	ld a,l
	call	$1fa3
	ld	hl,0	; return code, nothing (yet) implemented
	ret

DEFC ASMDISP_SOS_FILE_CALLEE = # asmentry - sos_file_callee
