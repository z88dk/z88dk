;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;
;
; ------
; $Id: ozserinton.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozserinton

	LIB	ozcustomisr
	XREF	serial_hook
	XREF	serial_check_hook
	XREF	rxxoff_hook
	
	LIB	serial_int
	XREF	serial_int_check
	XREF	rxxoff_handler

ozserinton:
        ld      hl,serial_int
        ld      (serial_hook+1),hl
        ld      hl,serial_int_check
        ld      (serial_check_hook+1),hl
        ld      hl,rxxoff_handler
        ld      (rxxoff_hook+1),hl
        in a,(7)
        and 0ffh-4
        out (7),a
        ld a,1
        out (41h),a
        ret
