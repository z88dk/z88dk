    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN		bit_open
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
._bit_open_di
	ld	    a,($403B)
    ld      (__bit_irqstatus),a
	and	    @01111111	;Disable NMI (i.e. how interrupts are delivered), set 
	out	    ($0),a
    and     @01101111   ;Set piezzo to stand-by
	ld	    (__snd_tick),a
    ret

