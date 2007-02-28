;
;	RCM2/3000 clock() function
;
; --------
; $Id: clock.asm,v 1.1 2007-02-28 11:23:24 stefano Exp $

	;;  TODO:	 WRITE ME !!! use rtc in some way..

	XLIB	clock

.clock
; 16436/7 word running backwards from 65535 to 32768 (bit 15 always set).
; It is reset by basic if running a PAUSE statement.

	ld	hl,65535
	ld	de,(16436)
	scf
	ccf
	sbc	hl,de
	ld	de,0
	ret
