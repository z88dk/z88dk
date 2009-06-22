; $Id: bit_open_di.asm,v 1.3 2009-06-22 21:44:16 dom Exp $
;
; Z88 1 bit sound functions
;
; Open sound port and disable interrupts for exact timing
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    XLIB     bit_open_di
    INCLUDE  "interrpt.def"

    XREF     snd_asave
    XREF     snd_tick

.bit_open_di
          call oz_di
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (snd_tick),a
          ret
