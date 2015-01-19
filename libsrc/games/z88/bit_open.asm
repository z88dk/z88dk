; $Id: bit_open.asm,v 1.4 2015-01-19 01:32:45 pauloscustodio Exp $
;
; Z88 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    PUBLIC     bit_open
    INCLUDE  "interrpt.def"

    EXTERN     snd_asave
    EXTERN     snd_tick

.bit_open
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (snd_tick),a
          ret
