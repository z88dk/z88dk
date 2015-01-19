; $Id: bit_open.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; ZX81 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 11/11/2001
;

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
	  xor a
	  ret
