;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;	buffered serial input
;
; ------
; $Id: ozclearserialbuffer.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozclearserialbuffer

	LIB	serial_int
	XREF	SerialBuffer
	XREF	ozserbufget
	XREF	ozrxxoff


ozclearserialbuffer:
        ld      hl,ozserbufget
        ld      a,(hl)
        inc     hl
        ld      (hl),a
        xor     a
        ld      (ozrxxoff),a
        ret
