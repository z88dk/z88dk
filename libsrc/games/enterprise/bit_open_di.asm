; $Id: bit_open_di.asm,v 1.1 2011-03-18 07:12:41 stefano Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; (Open sound port) and disable interrupts for exact timing
;
; Stefano Bodrato - 2011
;

    XLIB     bit_open_di
    
.bit_open_di
	di
	
	ld      a,@00001000	; Set D/A mode on left channel
	out     ($A7),a

	ret

