; $Id: bit_open_di.asm,v 1.4 2013-10-21 14:23:45 stefano Exp $
;
; ZX Spectrum 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 28/9/2001
;

    XLIB     bit_open_di
    XREF     snd_tick
    XREF     bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl
        
        ld a,(23693)
        rra
        rra
        rra
        and 7
        or	8
        push de
        ld	e,a
        ld  a,(snd_tick)
        and sndbit_mask
        or e
        pop de
        ld	(snd_tick),a
        
          ;ld  a,(snd_tick)
        ret
