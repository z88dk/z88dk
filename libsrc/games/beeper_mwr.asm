; $Id: beeper_mwr.asm,v 1.5 2016-06-11 20:52:25 dom Exp $
;
; 1 bit sound library - version for "memory write" I/O architectures
; by Stefano Bodrato, 31/03/08
;
; ZX Spectrum-like call:
; HL=duration
; DE=frequency
;

    SECTION    code_clib
    PUBLIC     beeper
    PUBLIC     _beeper
    INCLUDE  "games/games.inc"
    EXTERN     __snd_tick

    EXTERN      bit_open_di
    EXTERN      bit_close_ei

.beeper
._beeper
	push	ix
          ld   a,l
          srl  l
          srl  l
          cpl
          and  3
          ld   c,a
          ld   b,0
          ld   ix,beixp3
          add  ix,bc
          call bit_open_di
.beixp3
          nop
          nop
          nop
          inc  b
          inc  c
.behllp   dec  c
          jr   nz,behllp
          ld   c,$3F
          dec  b
          jp   nz,behllp
          xor  sndbit_mask
          ld   (sndbit_port),a		; This is three cycles slower tha the OUT based version
          ld   b,h
          ld   c,a
          bit  sndbit_bit,a            ;if o/p go again!
          jr   nz,be_again
          ld   a,d
          or   e
          jr   z,be_end
          ld   a,c
          ld   c,l
          dec  de
          jp   (ix)
.be_again
          ld   c,l
          inc  c
          jp   (ix)
.be_end
          call   bit_close_ei
	pop	ix
          ret
