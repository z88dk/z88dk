; $Id: bit_open_di.asm,v 1.4 2016-04-23 21:06:32 dom Exp $
;
; Generic 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
; Current interrupt status is saved
;
; Stefano Bodrato - 2001..2013
;

    SECTION    code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN     snd_tick
    EXTERN     bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
._bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl
        
        ld  a,(snd_tick)
        ret
