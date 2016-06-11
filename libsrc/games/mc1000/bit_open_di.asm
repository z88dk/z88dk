; $Id: bit_open_di.asm,v 1.4 2016-06-11 20:52:25 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open_di();
;
; Ensjo - 2013
;



    PUBLIC     bit_open_di
    EXTERN		bit_open
    EXTERN     snd_tick
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

