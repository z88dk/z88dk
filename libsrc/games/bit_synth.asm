; $Id: bit_synth.asm $
;
; void bit_synth(int duration, int frequency1, int frequency2, int frequency3, int frequency4);
;
; Generic platform sound library.
; synthetizer - this is a sort of "quad sound" routine.
; It is based on 4 separate counters and a delay.
; Depending on the parameters being passed it is able to play
; on two audible voices, to generate sound effects and to play
; with a single voice having odd waveforms.
;
; The parameters are passed with a self modifying code trick  :o(
; This routine shouldn't stay in contended memory locations !!
;

IF !__CPU_GBZ80__ && !__CPU_INTEL__
          SECTION    smc_clib
          PUBLIC     bit_synth
          PUBLIC     _bit_synth
          PUBLIC     bit_synth_callee
          PUBLIC     _bit_synth_callee
		  
          ;  ASM driven bending for special effects  ;)
          PUBLIC     bit_synth_sub    ; entry
          PUBLIC     bit_synth_len    ; duration
          ; FR*_tick should hold the XOR instruction.
          ; FR*_tick+1 should be set to 0 or to SOUND_ONEBIT_mask
          PUBLIC     FR1_tick
          PUBLIC     FR2_tick
          PUBLIC     FR3_tick
          PUBLIC     FR4_tick
		  ; FR_*+1 needs to be loaded with the 4 sound periods
          PUBLIC     FR_1
          PUBLIC     FR_2
          PUBLIC     FR_3
          PUBLIC     FR_4
		  		  
          INCLUDE  "games/games.inc"

          EXTERN      bit_open_di
          EXTERN      bit_close_ei


.bit_synth_callee
._bit_synth_callee
		pop hl
		ld	(ret_addr1+1),hl
		call bit_synth
		pop  de
		pop  de
		pop  de
		pop  de
		pop  de
.ret_addr1
		jp   0

.bit_synth
._bit_synth

		pop hl
		ld	(ret_addr+1),hl
		  push    ix
          ld      ix,2
          add     ix,sp
          ld      a,(ix+8)
          ld      (bit_synth_len+1),a
          ld      a,(ix+6)
          and     a
          jr      z,FR1_blank
          ld      (FR_1+1),a
          ld      a,SOUND_ONEBIT_mask
.FR1_blank
          ld      (FR1_tick+1),a
          ld      a,(ix+4)
          and     a
          jr      z,FR2_blank
          ld      (FR_2+1),a
          ld      a,SOUND_ONEBIT_mask
.FR2_blank
          ld      (FR2_tick+1),a
          ld      a,(ix+2)
          and     a
          jr      z,FR3_blank
          ld      (FR_3+1),a
          ld      a,SOUND_ONEBIT_mask
.FR3_blank
          ld      (FR1_tick+1),a
          ld      a,(ix+0)
          and     a
          jr      z,FR4_blank
          ld      (FR_4+1),a
          ld      a,SOUND_ONEBIT_mask
.FR4_blank
          ld      (FR1_tick+1),a


          call    bit_open_di		  
		  call    bit_synth_sub
		  pop     ix
          call    bit_close_ei

.ret_addr
          jp      0


.bit_synth_sub
          push    hl
          push    de
          push    bc

        IF SOUND_ONEBIT_port >= 256
          exx
          ld   bc,SOUND_ONEBIT_port
          exx
        ENDIF

          ld      h,1
          ld      l,h
          ld      d,h
          ld      e,h
.bit_synth_len
          ld      b,50
.loop
          ld      c,4
.loop2
          dec     h
          jr      nz,jump
.FR1_tick
          xor     SOUND_ONEBIT_mask

        IF SOUND_INOUT = 1
          exx
          ld   c,a
          jr nz,ASMPC+6
          in  a,(SOUND_ONEBIT_port)
          jr  ASMPC+4
          out  (SOUND_ONEBIT_port),a
          ld   a,c
          exx
        ELIF SOUND_IFF = 1
          jp      nz,ASMPC+4
          di
          jp      ASMPC+4
          ei
        ELIF SOUND_ONEBIT_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELIF SOUND_ONEBIT_port < 0
          ld  (-SOUND_ONEBIT_port),a
        ELSE
          out  (SOUND_ONEBIT_port),a
        ENDIF

.FR_1
          ld      h,80
.jump
          dec     l
          jr      nz,jump2
.FR2_tick
          xor     SOUND_ONEBIT_mask

        IF SOUND_INOUT = 1
          exx
          ld   c,a
          jr nz,ASMPC+6
          in  a,(SOUND_ONEBIT_port)
          jr  ASMPC+4
          out  (SOUND_ONEBIT_port),a
          ld   a,c
          exx
        ELIF SOUND_IFF = 1
          jp      nz,ASMPC+4
          di
          jp      ASMPC+4
          ei
        ELIF SOUND_ONEBIT_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELIF SOUND_ONEBIT_port < 0
          ld  (-SOUND_ONEBIT_port),a
        ELSE
          out  (SOUND_ONEBIT_port),a
        ENDIF

.FR_2
          ld      l,81
.jump2
          dec     d
          jr      nz,jump3
.FR3_tick
          xor     SOUND_ONEBIT_mask

        IF SOUND_INOUT = 1
          exx
          ld   c,a
          jr nz,ASMPC+6
          in  a,(SOUND_ONEBIT_port)
          jr  ASMPC+4
          out  (SOUND_ONEBIT_port),a
          ld   a,c
          exx
        ELIF SOUND_IFF = 1
          jp      nz,ASMPC+4
          di
          jp      ASMPC+4
          ei
        ELIF SOUND_ONEBIT_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELIF SOUND_ONEBIT_port < 0
          ld  (-SOUND_ONEBIT_port),a
        ELSE
          out  (SOUND_ONEBIT_port),a
        ENDIF

.FR_3
          ld      d,162
.jump3
          dec     e
          jr      nz,loop2
.FR4_tick
          xor     SOUND_ONEBIT_mask

        IF SOUND_INOUT = 1
          exx
          ld   c,a
          jr nz,ASMPC+6
          in  a,(SOUND_ONEBIT_port)
          jr  ASMPC+4
          out  (SOUND_ONEBIT_port),a
          ld   a,c
          exx
        ELIF SOUND_IFF = 1
          jp      nz,ASMPC+4
          di
          jp      ASMPC+4
          ei
        ELIF SOUND_ONEBIT_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELIF SOUND_ONEBIT_port < 0
          ld  (-SOUND_ONEBIT_port),a
        ELSE
          out  (SOUND_ONEBIT_port),a
        ENDIF

.FR_4
          ld      e,163
          
          dec     c
          jr      nz,loop2
          djnz    loop

          pop     bc
          pop     de
          pop     hl

		  ret

ENDIF
