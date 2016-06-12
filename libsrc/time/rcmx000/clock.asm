;
;	RCM2/3000 clock() function
;
; --------
; $Id: clock.asm,v 1.3 2016-06-12 17:02:26 dom Exp $

	;;  TODO:	 WRITE ME !!! use rtc in some way..

        SECTION code_clib
	PUBLIC clock
	PUBLIC _clock

.clock
._clock
; 16436/7 word running backwards from 65535 to 32768 (bit 15 always set).
; It is reset by basic if running a PAUSE statement.

	ld	hl,65535
	ld	de,(16436)
	scf
	ccf
	sbc	hl,de
	ld	de,0
	ret
