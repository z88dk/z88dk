;
; Small C z88 Misc functions
;
; sleep(time)
;
; Pause for time seconds
;
; djm 22/3/2000 Rewritten to:
;		 - Not loop (was causing problems)
;		 - Return number of seconds left
;
; -----
; $Id: sleep.asm,v 1.4 2009-06-22 21:44:17 dom Exp $


		INCLUDE "time.def"

                XLIB    sleep
		LIB	l_mult
		LIB	l_div_u
		XDEF ASMDISP_SLEEP

;sleep(int time);


.sleep
        pop     hl
        pop     de      ;number of seconds..
        push    de
        push    hl
        
.asmentry
                
	ld	hl,100
	call	l_mult
	ld	c,l
	ld	b,h
        call_oz(os_dly)
	ld	hl,0
	ret	nc	;NULL - normal
; Now found out how long is left to sleep for..
	ld	e,c
	ld	d,b
	ld	hl,100
	call	l_div_u
	ld	c,l
	ld	b,h
	ret	

DEFC ASMDISP_SLEEP = asmentry - sleep

