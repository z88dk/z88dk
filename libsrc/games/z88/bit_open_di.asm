; $Id: bit_open_di.asm,v 1.7 2016-04-23 21:06:32 dom Exp $
;
; Z88 1 bit sound functions
;
; Open sound port and disable interrupts for exact timing
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    SECTION    code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    INCLUDE  "interrpt.def"

    EXTERN     bit_irqstatus

    EXTERN     snd_asave
    EXTERN     snd_tick

.bit_open_di
._bit_open_di

          ld a,i		; get the current status of the irq line
          call oz_di
          push af
          ex (sp),hl
          ld (bit_irqstatus),hl
          pop hl
          
          ld   (snd_asave),a
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
          ld   (snd_tick),a
          ret
