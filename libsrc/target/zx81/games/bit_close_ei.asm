; $Id: bit_close_ei.asm,v 1.3 2016-06-16 20:23:52 dom Exp $
;
; ZX81 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 11/11/2011
;

    SECTION code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei

.bit_close_ei
._bit_close_ei
        ; ld     ix,16384
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        ret    z
        out ($fe),a					; turn on interrupt
        ret
