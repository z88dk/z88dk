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
; $Id: ozserinton.asm,v 1.4 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozserinton
	PUBLIC	_ozserinton

	EXTERN	ozcustomisr
	EXTERN	serial_hook
	EXTERN	rxxoff_hook

	EXTERN	ozintwait
	EXTERN	serial_check_hook
	
	EXTERN	serial_int
	EXTERN	serial_int_check
	EXTERN	rxxoff_handler

ozserinton:
_ozserinton:
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
