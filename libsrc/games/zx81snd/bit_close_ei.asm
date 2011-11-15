; $Id: bit_close_ei.asm,v 1.1 2011-11-15 16:40:47 stefano Exp $
;
; ZX81 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 11/11/2011
;

    XLIB     bit_close_ei

.bit_close_ei
        ld     ix,16384
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        ret    z
        out ($fe),a					; turn on interrupt
        ret
