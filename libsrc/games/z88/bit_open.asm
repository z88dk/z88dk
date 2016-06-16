; $Id: bit_open.asm,v 1.7 2016-06-16 19:34:00 dom Exp $
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
    EXTERN     __snd_tick

.bit_open
._bit_open
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (__snd_tick),a
          ret

    SECTION   bss_clib
snd_asave:	defb	0

