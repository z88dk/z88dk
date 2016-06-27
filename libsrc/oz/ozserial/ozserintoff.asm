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
; $Id: ozserintoff.asm,v 1.4 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozserintoff
	PUBLIC	_ozserintoff

	EXTERN	ozcustomisr
	EXTERN	serial_hook
	EXTERN	rxxoff_hook

	EXTERN	ozintwait
	EXTERN	serial_check_hook
	
ozserintoff:
_ozserintoff:
        ld      hl,serial_hook+3
        ld      (serial_hook+1),hl
        ld      hl,serial_check_hook+3
        ld      (serial_check_hook+1),hl
        ld      hl,rxxoff_hook+3
        ld      (rxxoff_hook+1),hl
        in a,(7)
        or 4
        out (7),a
        ld a,0
        out (41h),a
        ret
