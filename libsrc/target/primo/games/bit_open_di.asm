    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN		bit_open
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
._bit_open_di
	in	a,($0)
	and	@00101111	;Disable NMI (i.e. how interrupts are delivered)
	or	@00001000
	out	($0),a
	ld	(__snd_tick),a
        ret

