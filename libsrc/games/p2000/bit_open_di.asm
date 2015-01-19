; $Id: bit_open_di.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Philips P2000 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - Apr 2014
;

    PUBLIC     bit_open_di
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
        
          ld   a,1
          ld   (snd_tick),a

        ret
