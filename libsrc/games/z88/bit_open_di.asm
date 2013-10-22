; $Id: bit_open_di.asm,v 1.5 2013-10-22 07:18:26 stefano Exp $
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

    XREF     bit_irqstatus

    XREF     snd_asave
    XREF     snd_tick

.bit_open_di

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
