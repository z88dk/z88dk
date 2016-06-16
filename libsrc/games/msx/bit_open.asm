; $Id: bit_open.asm,v 1.4 2016-06-16 20:23:51 dom Exp $
;
; MSX bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 3/12/2007
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

;Port 0AAh, PPI Port C - Keyboard Row,LED,Cassette (Read/Write)
;  Bit  Name   Expl.
;  0-3  KB0-3  Keyboard line               (0-8 on SV738 X'Press)
;  4    CASON  Cassette motor relay        (0=On, 1=Off)
;  5    CASW   Cassette audio out          (Pulse)
;  6    CAPS   CAPS-LOCK lamp              (0=On, 1=Off)
;  7    SOUND  Keyboard klick bit          (Pulse)

 
.bit_open
._bit_open
          ld    a,@11110000
          ld   (__snd_tick),a
          ret
