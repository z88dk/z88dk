; $Id: bit_open_di.asm,v 1.1 2007-12-03 16:05:19 stefano Exp $
;
; MSX bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 3/12/2007
;

    XLIB     bit_open_di
    XREF     snd_tick


;Port 0AAh, PPI Port C - Keyboard Row,LED,Cassette (Read/Write)
;  Bit  Name   Expl.
;  0-3  KB0-3  Keyboard line               (0-8 on SV738 X'Press)
;  4    CASON  Cassette motor relay        (0=On, 1=Off)
;  5    CASW   Cassette audio out          (Pulse)
;  6    CAPS   CAPS-LOCK lamp              (0=On, 1=Off)
;  7    SOUND  Keyboard klick bit          (Pulse)

 
.bit_open_di
          di
          ld    a,@11110000
          ld   (snd_tick),a
          ret
