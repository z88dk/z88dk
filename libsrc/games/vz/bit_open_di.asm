; $Id: bit_open_di.asm,v 1.2 2013-10-22 06:09:32 stefano Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

    XLIB     bit_open_di
    XREF     snd_tick
    XREF     bit_irqstatus

.bit_open_di

        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl

          ld    a,($783b)
          ld   (snd_tick),a
          ret
