; $Id: bit_fx6.asm  $
;
; A "memory write" I/O variant is not necessary,
; this effects library is totally based on the external "beeper" fn
;
; Generic platform sound effects module.
;
; Library #6 by Stefano Bodrato
;

IF !__CPU_GBZ80__ 
          SECTION    code_clib
          PUBLIC     bit_fx6
          PUBLIC     _bit_fx6
          INCLUDE  "games/games.inc"

          EXTERN      bit_open
          EXTERN      bit_open_di
          EXTERN      bit_close
          EXTERN      bit_close_ei

          ;  ASM driven bending for special effects  ;)
          EXTERN     bit_synth_sub    ; entry
          EXTERN     bit_synth_len    ; sound duration
		  ; FR*_tick should hold the XOR instruction.
		  ; FR*_tick+1 should be set to 0 or to SOUND_ONEBIT_mask
          EXTERN     FR1_tick
          EXTERN     FR2_tick
          EXTERN     FR3_tick
          EXTERN     FR4_tick
		  ; FR_*+1 needs to be loaded with the 4 sound periods
          EXTERN     FR_1
          EXTERN     FR_2
          EXTERN     FR_3
          EXTERN     FR_4

;Sound routine..enter in with e holding the desired effect!


.bit_fx6
._bit_fx6
		
		; Initialize the synthetizer
		ld	a,SOUND_ONEBIT_mask
		ld	(FR_1+1),a
		ld	(FR_2+1),a
		ld	(FR_3+1),a
		ld	(FR_4+1),a

          ld    a,l
          cp    8
          ret   nc  
          add   a,a  
          ld    e,a  
          ld    d,0  
          ld    hl,table  
          add   hl,de  
          ld    a,(hl)  
          inc   hl  
          ld    h,(hl)  
          ld    l,a  
          jp    (hl)  
          
.table    defw    fx1		; effect #0
          defw    fx2
          defw    fx3
          defw    fx4
          defw    fx5
          defw    fx6
          defw    fx7
          defw    fx8
          
          
; Level up
.fx1
		  
          call  bit_open_di
		  ld    b,40

.bloop
          ld    e,a
		  ld    a,b
		  ld    (FR_1+1),a
		  inc   a
  		  ld    (bit_synth_len+1),a
		  ld    (FR_2+1),a
		  inc   a
		  ld    (FR_3+1),a
		  inc   a
		  ld    (FR_4+1),a

		  ld    a,e
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  djnz  bloop

          jp    bit_close_ei


.fx2
		  
          call  bit_open_di
		  ld    b,40

.bloop2
          ld    e,a
		  ld    a,50
		  sub   b
		  ld    (FR_1+1),a
		  inc   a
		  ld    (FR_2+1),a
		  inc   a
		  ld    (FR_3+1),a
		  inc   a
		  ld    (FR_4+1),a

		  ld    a,b
IF __CPU_INTEL__
    rrca
    rrca
    and     @00111111
ELSE
		  srl   a
		  srl   a
ENDIF
		  inc   a
  		  ld    (bit_synth_len+1),a

		  ld    a,e
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  djnz  bloop2

          jp    bit_close_ei


; Level up II
.fx3
		  
          call  bit_open_di
		  ld    b,40

.bloop3
          ld    e,a
		  ld    a,b
		  ld    (FR_1+1),a
		  inc   a
  		  ld    (bit_synth_len+1),a
		  inc   a
		  ld    (FR_2+1),a
		  ld	a,42
		  sub   b
		  ld    (FR_3+1),a
		  inc   a
		  ld    (FR_4+1),a

		  ld    a,e
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  djnz  bloop3

          jp    bit_close_ei


.fx4
		  
		  ld    a,5
  		  ld    (bit_synth_len+1),a

          call  bit_open_di
		  ld    b,3

.bloop4
          ld    e,a
		  ld    a,50
		  sub   b
		  ld    (FR_1+1),a
		  add   20
		  ld    (FR_2+1),a
		  add   30
		  ld    (FR_3+1),a
		  ld	a,60
		  sub   a
		  ld    (FR_4+1),a

		  ld    a,e
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  djnz  bloop4

          jp    bit_close_ei



.fx5
		  ld    a,5
  		  ld    (bit_synth_len+1),a

          call  bit_open_di
		  ld    b,10

.bloop5
          ld    e,a
		  ld    a,b
		  ld    (FR_1+1),a
		  add   20
		  ld    (FR_2+1),a
		  add   30
		  ld    (FR_3+1),a
		  ld	a,60
		  sub   a
		  ld    (FR_4+1),a

		  ld    a,e
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  djnz  bloop5

          jp    bit_close_ei


.fx6

		  ld    a,8
  		  ld    (bit_synth_len+1),a

          call  bit_open_di

		  ld    b,250

.bloop6
          ld    e,a
		  ld    a,b
		  ld    (FR_1+1),a
		  sub   4
		  ld    (FR_2+1),a
		  sub   15
		  ld    (FR_3+1),a
		  sub   35
		  ld    (FR_4+1),a
		  ld    a,e
		  
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  
		  jr	nz,bloop6

          jp    bit_close_ei



.fx7
		  ld    a,8
  		  ld    (bit_synth_len+1),a

          call  bit_open_di

          ld    e,a
		  ld    a,255
		  ld    (FR_1+1),a
		  sub   1
		  ld    (FR_2+1),a
		  sub   10
		  ld    (FR_3+1),a
		  sub   1
		  ld    (FR_4+1),a
		  ld    a,e
		  
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  
          jp    bit_close_ei


.fx8
		  ld    a,8
  		  ld    (bit_synth_len+1),a

          call  bit_open_di

          ld    e,a
		  ld    a,255
		  ld    (FR_1+1),a
		  sub   100
		  ld    (FR_2+1),a
		  sub   10
		  ld    (FR_3+1),a
		  sub   40
		  ld    (FR_4+1),a
		  ld    a,e
		  
		  push  bc
          call  bit_synth_sub
		  pop   bc
		  
          jp    bit_close_ei


ENDIF
