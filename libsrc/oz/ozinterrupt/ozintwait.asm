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
; $Id: ozintwait.asm,v 1.1 2003-10-23 10:42:50 stefano Exp $
;

	XLIB	ozintwait
	LIB	ozcustomisr
	
	XDEF	serial_check_hook

	XREF	KeyBufGetPos
	XREF	KeyBufPutPos


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

