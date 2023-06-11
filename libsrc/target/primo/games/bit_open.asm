    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN      bit_close
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

.bit_open
._bit_open
	ld	    a,($403B)
	and	    @11101111	;Set piezzo to stand by, leave NMI interrupt
    ld      (__snd_tick),a
	ret
