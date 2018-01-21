;
;	clock() for the Amstrad CPC
;
;	Stefano 2017
;
;      Action: Returns the time that  has  elapsed  since the computer
;              was switched on or reset (in 1/300ths of a second)
;      Exit:   DEHL contains the four byte  count of the time elapsed,
;              and all other registers are preserved
;
; ------
; $Id: clock.asm $
;

        SECTION code_clib
		
	PUBLIC	clock
	PUBLIC	_clock

	INCLUDE "target/cpc/def/cpcfirm.def"
	
	
.clock
._clock

	call    firmware
	defw    kl_time_please

	ret
