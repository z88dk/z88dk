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
; $Id: ozserialgetc.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozserialgetc
	PUBLIC	_ozserialgetc

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozserbufget
	EXTERN	ozserbufput


ozserialgetc:
_ozserialgetc:
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
