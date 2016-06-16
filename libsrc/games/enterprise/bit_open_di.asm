; $Id: bit_open_di.asm,v 1.5 2016-06-16 19:33:59 dom Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; (Open sound port) and disable interrupts for exact timing
;
; Stefano Bodrato - 2011
;


    PUBLIC     bit_open_di
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (__bit_irqstatus),hl
        pop hl
        
		ld      a,@00001000	; Set D/A mode on left channel
		out     ($A7),a
        ld  a,(__snd_tick)
        ret
