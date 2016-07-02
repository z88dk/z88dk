;
; Small C z88 Misc functions
;
; sleep(time)
;
; Pause for time centiseconds
;
; djm 1/12/98
;
; If we can't have usleep we'll have csleep instead!
;
; -----
; $Id: csleep.asm,v 1.9 2016-07-02 15:44:16 dom Exp $


		MODULE  csleep_z88
		SECTION	code_clib
                INCLUDE "time.def"

                PUBLIC    csleep
                PUBLIC    _csleep
                PUBLIC    ASMDISP_CSLEEP


;csleep(int time);


.csleep
._csleep
        pop     hl
        pop     bc      ;number of centi-seconds..
        push    bc
        push    hl

.asmentry

        ld      a,b
        or      c
        jr      z,csleep1
        call_oz(os_dly)		;preserves ix
        ld      hl,1
        ret     c
.csleep1
        ld      hl,0
        ret

DEFC ASMDISP_CSLEEP = # asmentry - csleep

