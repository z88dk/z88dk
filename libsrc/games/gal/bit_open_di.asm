; $Id: bit_open_di.asm,v 1.3 2013-10-21 14:23:45 stefano Exp $
;
; Galaksija 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
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
        
          ld   a,@10111000
          ld   (snd_tick),a
          ld   (8248),a

        ret

