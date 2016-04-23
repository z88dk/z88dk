; $Id: bit_close.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;
; Z88 1 bit sound functions
;
; void bit_close();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;
    SECTION    code_clib
    PUBLIC     bit_close
    PUBLIC     _bit_close
    INCLUDE  "interrpt.def"

    EXTERN     snd_asave

.bit_close
._bit_close
          ld   a,(snd_asave)
          ret

