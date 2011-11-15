; $Id: bit_open_di.asm,v 1.1 2011-11-15 16:40:47 stefano Exp $
;
; ZX81 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 11/11/2011
;

    XLIB     bit_open_di
    XREF     snd_tick

.bit_open_di
        ld     a,(16443)	; test CDFLAG
        and    128			; is in FAST mode ?
        jr     z,nodi
        out    ($fd),a         ; turn off interrupt
.nodi
        xor    a
        ret
