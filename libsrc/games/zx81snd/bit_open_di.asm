; $Id: bit_open_di.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; ZX81 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 11/11/2011
;

    PUBLIC     bit_open_di
    EXTERN     snd_tick

.bit_open_di
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nodi
        out    ($fd),a         ; turn off interrupt
.nodi
        xor    a
        ret
