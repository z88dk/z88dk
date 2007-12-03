; $Id: bit_open.asm,v 1.1 2007-12-03 16:05:19 stefano Exp $
;
; MSX bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 3/12/2007
;

    XLIB     bit_open
    XREF     snd_tick

;Port 0AAh, PPI Port C - Keyboard Row,LED,Cassette (Read/Write)
;  Bit  Name   Expl.
;  0-3  KB0-3  Keyboard line               (0-8 on SV738 X'Press)
;  4    CASON  Cassette motor relay        (0=On, 1=Off)
;  5    CASW   Cassette audio out          (Pulse)
;  6    CAPS   CAPS-LOCK lamp              (0=On, 1=Off)
;  7    SOUND  Keyboard klick bit          (Pulse)

 
.bit_open
          ld    a,@11110000
          ld   (snd_tick),a
          ret
