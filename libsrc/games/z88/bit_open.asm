; $Id: bit_open.asm,v 1.6 2016-05-17 21:43:06 dom Exp $
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

    PUBLIC     snd_asave
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

    SECTION   bss_clib
snd_asave:	defb	0

