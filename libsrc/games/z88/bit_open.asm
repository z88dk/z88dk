; $Id: bit_open.asm,v 1.2 2002-04-17 21:30:24 dom Exp $
;
; Z88 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    XLIB     bit_open
    INCLUDE  "#interrpt.def"

    XREF     snd_asave
    XREF     snd_tick

.bit_open
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (snd_tick),a
          ret
