; $Id: bit_close.asm,v 1.2 2002-04-17 21:30:24 dom Exp $
;
; Z88 1 bit sound functions
;
; void bit_close();
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    XLIB     bit_close
    INCLUDE  "#interrpt.def"

    XREF     snd_asave

.bit_close
          ld   a,(snd_asave)
          ret

