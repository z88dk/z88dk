; $Id: patch_beeper.asm $
;
; Generic 1 bit sound functions
;

IF !__CPU_GBZ80__ && !__CPU_INTEL__
    ;SECTION    code_clib
    SECTION    smc_clib
    
    PUBLIC     patch_beeper
    PUBLIC     _patch_beeper
    INCLUDE  "games/games.inc"

    ;EXTERN      bit_open_di
    ;EXTERN      bit_close_ei
    
    EXTERN      __snd_tick

;
;  Pattern controlled buzzer, approx. timing
;  by Stefano Bodrato, Jan/2021
;


.patch_beeper
._patch_beeper
          push  ix
		  push bc	; bit pattern
		  pop  ix
		  push ix

        IF SOUND_ONEBIT_port >= 256
          exx
          ld   bc,SOUND_ONEBIT_port
          exx
        ENDIF
          ld   a,l
          srl  l
          srl  l
          cpl
          and  3
          ld   c,a
          ld   b,0
          ;ld   ix,beixp3
          ;add  ix,bc
          ;call bit_open_di
          ;ld   a,(__snd_tick)

.beixp3
          ;nop
          ;nop
          ;nop
		  
          inc  b
          inc  c
.behllp   dec  c
          jr   nz,behllp
          ld   c,$3F
          dec  b
          jp   nz,behllp
          
          ld   a,e
          and  7
          jr   nz,no_pattern_loop
		  
          inc  ix
          ld   a,(ix+0)
          and  a
          jr   nz,no_pattern_loop
          pop  ix	; back to the beginning of bit pattern
          push ix	; 14T
;          jr   compensate
.no_pattern_loop
;          push ix	; 14T
;          pop  ix	; back to the beginning of bit pattern
;.compensate

          rlc  (ix+0)
		  sbc  a,a	; 0 or FF
		  and  SOUND_ONEBIT_mask
		  ld   c,a
          ld   a,(__snd_tick)
          xor  c

    ONEBITOUT


          ld   b,h
          ld   c,a
          ;bit  SOUND_ONEBIT_bit,a            ;if o/p go again!
          ;jr   nz,be_again
          ld   a,d
          or   e
          jr   z,be_end
          ld   a,c
          ld   c,l
          dec  de
          ;jp   (ix)
		  jp	beixp3
;.be_again
;          ld   c,l
;          inc  c
;          jp   (ix)
.be_end
          pop   ix
          pop   ix
          ;call   bit_close_ei
          ret

ENDIF

