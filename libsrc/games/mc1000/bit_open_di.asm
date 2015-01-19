; $Id: bit_open_di.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
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
    EXTERN     bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl
        
        call bit_open

        ret

