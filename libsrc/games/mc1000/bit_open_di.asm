; $Id: bit_open_di.asm,v 1.2 2013-10-21 14:23:45 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open_di();
;
; Ensjo - 2013
;



    XLIB     bit_open_di
    LIB		bit_open
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
        
        call bit_open

        ret

