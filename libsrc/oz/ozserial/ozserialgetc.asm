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
; $Id: ozserialgetc.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozserialgetc

	LIB	serial_int
	XREF	SerialBuffer
	XREF	ozserbufget
	XREF	ozserbufput


ozserialgetc:
        ld      a,(ozserbufget)
        ld      e,a
        ld      a,(ozserbufput)
        cp      e
        jr      z,NothingInBuffer
        ld      l,e
        ld      h,0
        ld      bc,SerialBuffer
        add     hl,bc
        ld      a,(hl)
        ld      l,a
        ld      h,0
        ld      a,e
        inc     a
        ld      (ozserbufget),a
        ret
NothingInBuffer:
        ld      hl,-1
        ret
