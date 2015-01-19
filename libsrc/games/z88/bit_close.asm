; $Id: bit_close.asm,v 1.4 2015-01-19 01:32:45 pauloscustodio Exp $
;
; Z88 1 bit sound functions
;
; void bit_close();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    PUBLIC     bit_close
    INCLUDE  "interrpt.def"

    EXTERN     snd_asave

.bit_close
          ld   a,(snd_asave)
          ret

