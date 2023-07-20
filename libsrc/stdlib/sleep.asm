
	SECTION code_clib
	PUBLIC	sleep
	PUBLIC	_sleep
	PUBLIC	_sleep_fastcall
	PUBLIC	sleep_fastcall

	EXTERN	msleep_fastcall

sleep:
_sleep:
    pop     de
    pop     hl
    push    hl
    push    de
sleep_fastcall:
_sleep_fastcall:
    ld      a,h
    or      l
    ret     z
    push    hl
    ld      hl,1000
    call    msleep_fastcall
    pop     hl
    dec     hl
    jr      sleep_fastcall
