; $Id: bit_close_ei.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; ZX81 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 11/11/2011
;

    PUBLIC     bit_close_ei

.bit_close_ei
        ld     ix,16384
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        ret    z
        out ($fe),a					; turn on interrupt
        ret
