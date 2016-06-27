;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	custom interrupt code + key scanning
;	waits for a keystroke, serial data, or interrupt event
;
;
; ------
; $Id: ozintwait.asm,v 1.4 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozintwait
	PUBLIC	_ozintwait
	EXTERN	ozcustomisr
	
	PUBLIC	serial_check_hook

	EXTERN	KeyBufGetPos
	EXTERN	KeyBufPutPos


ozintwait:
_ozintwait:

        di
serial_check_hook:
        jp NoSerialCheck
;$serial_check_hook equ $-2
NoSerialCheck:
        ld a,(KeyBufGetPos)
        ld c,a
        ld a,(KeyBufPutPos)
        cp c
        jr nz,getout
        ei
        halt
getout:
        ei
        ret

