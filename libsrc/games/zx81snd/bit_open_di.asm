; $Id: bit_open_di.asm,v 1.3 2016-06-16 19:34:00 dom Exp $
;
; ZX81 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 11/11/2011
;

    PUBLIC     bit_open_di
    EXTERN     __snd_tick

.bit_open_di
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nodi
        out    ($fd),a         ; turn off interrupt
.nodi
        xor    a
        ret
