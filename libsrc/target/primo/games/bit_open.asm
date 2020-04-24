    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN      bit_close
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

.bit_open
._bit_open
	in	a,($0)
	and	@00101111	;Keep screen
	or	@10001000	;Enable interrupts
	or	$08		;original screen buffer
    	ld      (__snd_tick),a
	ret
