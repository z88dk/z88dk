; $Id: bit_open_di.asm,v 1.1 2014-07-16 09:59:57 stefano Exp $
;
; VG-5000 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 2014
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
        
        ld a,8
        ld	(snd_tick),a
        ret
