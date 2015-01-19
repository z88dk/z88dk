; $Id: bit_open_di.asm,v 1.3 2015-01-19 01:32:45 pauloscustodio Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

    PUBLIC     bit_open_di
    EXTERN     snd_tick
    EXTERN     bit_irqstatus

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
