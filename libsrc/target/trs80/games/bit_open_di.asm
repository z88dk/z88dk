; $Id: bit_open_di.asm,v 1.6 2016-06-16 20:23:52 dom Exp $
;
; TRS-80 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
._bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (__bit_irqstatus),hl
        pop hl
        
          ld   a,1
          ld   (__snd_tick),a

        ret
