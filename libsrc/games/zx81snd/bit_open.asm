; $Id: bit_open.asm,v 1.3 2016-06-16 19:34:00 dom Exp $
;
; ZX81 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 11/11/2001
;

    PUBLIC     bit_open
    EXTERN     __snd_tick

.bit_open
	  xor a
	  ret
