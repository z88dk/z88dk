
	SECTION code_clib
	PUBLIC	sleep
	PUBLIC	_sleep

	EXTERN	msleep

sleep:
_sleep:
        ld      a,h
        or      l
        ret     z
        push    hl
        ld      hl,1000
        call    msleep
        pop     hl
        dec     hl
        jr      sleep
