; $Id: bit_open_di.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; MSX bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 3/12/2007
;

    PUBLIC     bit_open_di
    EXTERN     snd_tick
    EXTERN     bit_irqstatus


;Port 0AAh, PPI Port C - Keyboard Row,LED,Cassette (Read/Write)
;  Bit  Name   Expl.
;  0-3  KB0-3  Keyboard line               (0-8 on SV738 X'Press)
;  4    CASON  Cassette motor relay        (0=On, 1=Off)
;  5    CASW   Cassette audio out          (Pulse)
;  6    CAPS   CAPS-LOCK lamp              (0=On, 1=Off)
;  7    SOUND  Keyboard klick bit          (Pulse)

 
.bit_open_di
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (bit_irqstatus),hl
        pop hl

          di
          ld    a,@11110000
          ld   (snd_tick),a
          ret
