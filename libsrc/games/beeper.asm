; $Id: beeper.asm,v 1.4 2013-10-21 14:23:44 stefano Exp $
;
; Generic 1 bit sound functions
;

    XLIB     beeper
    INCLUDE  "games/games.inc"

    LIB      bit_open_di
    LIB      bit_close_ei

;
; Ported by Dominic Morris
; Adapted by Stefano Bodrato
;
; Entry as for Spectrum beeper routine!!
; 
; Direct transfer, of code..no point commenting really
;


.beeper
        IF sndbit_port >= 256
          exx
          ld   bc,sndbit_port
          exx
        ENDIF
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

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

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
          ret

