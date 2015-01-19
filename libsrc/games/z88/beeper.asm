; $Id: beeper.asm,v 1.4 2015-01-19 01:32:45 pauloscustodio Exp $
;
; Z88 1 bit sound functions
;

    PUBLIC     beeper
    INCLUDE  "interrpt.def"

;
; Entry as for Spectrum beeper routine!!
; 
; Ported by Dominic Morris
; Direct transfer, of code..no point commenting really
;


.beeper
          call oz_di
          push af
          ld   a,l
          srl  l
          srl  l
          cpl
          and  3
          ld   c,a
          ld   b,0
          ld   ix,beixp3
          add  ix,bc
;OZ stuff here..
          ld   a,($4B0)
          and  63
          ld   ($4B0),a
          out  ($B0),a
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
          xor  64
          out  ($B0),a
          ld   b,h
          ld   c,a
          bit  6,a            ;if o/p go again!
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
          pop  af
          jp   oz_ei
