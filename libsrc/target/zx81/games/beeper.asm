; $Id: beeper.asm,v 1.3 2016-06-16 20:23:52 dom Exp $
;
; ZX81 1 bit sound functions
;
; Stefano Bodrato - 11/11/2011
;

    SECTION code_clib
    PUBLIC     beeper
    PUBLIC     _beeper

    INCLUDE  "games/games.inc"

    EXTERN      bit_open_di
    EXTERN      bit_close_ei

;
; Ported by Dominic Morris
; Adapted by Stefano Bodrato
;
; Spectrum beeper routine !!
; HL=duration
; DE=frequency
;
; Comments got from: http://www.wearmouth.demon.co.uk/scsra.htm
; ----------------------------------------------------------------
;
; Outputs a square wave of given duration and frequency
; to the loudspeaker.
;   Enter with: DE = #cycles - 1
;               HL = tone period as described next
;
; The tone period is measured in T states and consists of
; three parts: a coarse part (H register), a medium part
; (bits 7..2 of L) and a fine part (bits 1..0 of L) which
; contribute to the waveform timing as follows:
;
;                          coarse    medium       fine
; duration of low  = 118 + 1024*H + 16*(L>>2) + 4*(L&0x3)
; duration of hi   = 118 + 1024*H + 16*(L>>2) + 4*(L&0x3)
; Tp = tone period = 236 + 2048*H + 32*(L>>2) + 8*(L&0x3)
;                  = 236 + 2048*H + 8*L = 236 + 8*HL
;
; As an example, to output five seconds of middle C (261.624 Hz):
;   (a) Tone period = 1/261.624 = 3.822ms
;   (b) Tone period in T-States = 3.822ms*fCPU = 13378
;         where fCPU = clock frequency of the CPU = 3.5MHz
;   (c) Find H and L for desired tone period:
;         HL = (Tp - 236) / 8 = (13378 - 236) / 8 = 1643 = 0x066B
;   (d) Tone duration in cycles = 5s/3.822ms = 1308 cycles
;         DE = 1308 - 1 = 0x051B
;
; The resulting waveform has a duty ratio of exactly 50%.
; 
; ----------------------------------------------------------------


.beeper
._beeper
	push	ix	;save callers
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

;-----
          out  (255),a
          jp   z,isz

          ld   b,a
          in   a,(254)
          ld   a,b
.isz
;-----

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
	  pop	ix		;restore callers
          jp   bit_close_ei

