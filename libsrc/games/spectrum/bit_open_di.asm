; $Id: bit_open_di.asm,v 1.9 2016-06-16 19:33:59 dom Exp $
;
; ZX Spectrum 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 28/9/2001
;
    SECTION    code_clib
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
        
        ld a,(23624)
        rra
        rra
        rra
        and 7
        or	8
        push de
        ld	e,a
        ld  a,(__snd_tick)
        and sndbit_mask
        or e
        pop de
        ld	(__snd_tick),a
        ret
