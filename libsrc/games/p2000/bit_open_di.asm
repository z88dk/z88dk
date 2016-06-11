; $Id: bit_open_di.asm,v 1.3 2016-06-11 20:52:25 dom Exp $
;
; Philips P2000 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - Apr 2014
;

    PUBLIC     bit_open_di
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
        
          ld   a,1
          ld   (snd_tick),a

        ret
