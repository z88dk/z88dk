; $Id: noise.asm $
;
; Generic 1 bit sound functions
;

IF !__CPU_GBZ80__ && !__CPU_INTEL__
    SECTION    code_clib
    PUBLIC     noise
    PUBLIC     _noise
    INCLUDE  "games/games.inc"

    ;EXTERN      bit_open_di
    ;EXTERN      bit_close_ei
	
    EXTERN      asm_rand
    EXTERN      __snd_tick

;
; Ported by Dominic Morris
; Adapted by Stefano Bodrato
;
; Entry as for Spectrum noise routine!!
; 
; Direct transfer, of code..no point commenting really
;
          ; de = duration
          ; hl = period


.noise
._noise
          ;push	ix
          ld	bc,noise  ; point to myself to garble the bit patterns
		  push  bc
        IF sndbit_port >= 256
          exx
          ld   bc,sndbit_port
          exx
        ENDIF
;          ld   a,l
;          srl  l
;          srl  l
;          cpl
;          and  3
;          ld   c,a
          ld   b,0
          ;ld   ix,beixp3
          ;add  ix,bc

          ld	a,(__snd_tick)

.beixp3
          ;nop
          ;nop
          ;nop
          inc  b
          inc  c
.behllp   dec  c
          jr   nz,behllp
          ld   c,$1F
          dec  b
          jp   nz,behllp
		  
          ;ex  (sp),hl
          ;inc  l
          ;ld   b,a
		  ;ld   a,r		; more randomness
		  ;xor  (hl)
		  ;xor  l
          ;and  sndbit_mask
		  ;xor  b
          ;ex  (sp),hl
		  
		  push hl
		  push de
		  
		  push af
		  call asm_rand
		  
		  ;ld  a,h
		  ;xor l
		  ld  a,l
		  and  sndbit_mask
		  ld  l,a		  
		  pop af

		  xor l

        IF SOUND_INOUT = 1
          ld   c,a
          jr nz,ASMPC+6
          in  a,(sndbit_port)
          jr  ASMPC+4
          out  (sndbit_port),a
          ld   a,c
        ELIF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELIF sndbit_port < 0
          ld  (-sndbit_port),a
        ELSE
          out  (sndbit_port),a
        ENDIF

		  pop de
		  pop hl

          ld   b,h
          ld   c,a
          bit  sndbit_bit,a            ;if o/p go again!
          jr   nz,noise_again
		  
          ld   a,d
          or   e
          jr   z,noise_end
          ld   a,c
          ld   c,l
          dec  de
          ;jp   (ix)
		  jr   beixp3
.noise_again
          ld   c,l
          inc  c
          ;jp   (ix)
		  jr   beixp3
.noise_end
          pop   bc
          ;pop	ix
		  
          ret
		  
ENDIF
