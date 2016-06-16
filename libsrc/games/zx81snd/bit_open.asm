; $Id: bit_open.asm,v 1.4 2016-06-16 20:23:52 dom Exp $
;
; ZX81 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 11/11/2001
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
	  xor a
	  ret
