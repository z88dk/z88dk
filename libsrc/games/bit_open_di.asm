; $Id: bit_open_di.asm,v 1.1 2013-10-21 14:23:45 stefano Exp $
;
; Generic 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
; Current interrupt status is saved
;
; Stefano Bodrato - 2001..2013
;

    XLIB     bit_open_di
    XREF     snd_tick
    XDEf     bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_irqstatus
	defw 0

.bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl
        
        ld  a,(snd_tick)
        ret
