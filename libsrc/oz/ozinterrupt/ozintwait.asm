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
; $Id: ozintwait.asm,v 1.3 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozintwait
	EXTERN	ozcustomisr
	
	PUBLIC	serial_check_hook

	EXTERN	KeyBufGetPos
	EXTERN	KeyBufPutPos


ozintwait:

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

