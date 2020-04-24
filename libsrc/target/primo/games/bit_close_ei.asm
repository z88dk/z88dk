
    SECTION code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus
 

.bit_close_ei
._bit_close_ei
	ld	a,(__snd_tick)
	or	$80
	out	($0),a
	ret

