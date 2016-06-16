; $Id: bit_open_di.asm,v 1.5 2016-06-16 19:33:59 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open_di();
;
; Ensjo - 2013
;



    PUBLIC     bit_open_di
    EXTERN		bit_open
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
        
        call bit_open

        ret

