; $Id: bit_open.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;
; Z88 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    SECTION    code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    INCLUDE  "interrpt.def"

    EXTERN     snd_asave
    EXTERN     snd_tick

.bit_open
._bit_open
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (snd_tick),a
          ret
