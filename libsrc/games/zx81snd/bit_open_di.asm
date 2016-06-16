; $Id: bit_open_di.asm,v 1.4 2016-06-16 20:23:52 dom Exp $
;
; ZX81 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 11/11/2011
;

    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN     __snd_tick

.bit_open_di
._bit_open_di
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nodi
        out    ($fd),a         ; turn off interrupt
.nodi
        xor    a
        ret
