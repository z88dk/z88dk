; $Id: bit_fx.asm,v 1.8 2016-04-23 21:06:32 dom Exp $
;
; Generic platform sound effects module.
;
; Original code by Dominic Morris
; Adapted by Stefano Bodrato
;
;>Z88 sounds..hopefully!!
;>Works..kinda nice to hear the z88 sing..now for music!
;>djm June 1998
;>
;>This is quite a crude module, $4B0 isn't restored by most routines
;>due to the fact that it is usually in the 00xxxxxx state when we
;>get there

	SECTION     code_clib
          PUBLIC     bit_fx
          PUBLIC     _bit_fx
          INCLUDE  "games/games.inc"

          EXTERN      beeper
          EXTERN      bit_open
          EXTERN      bit_open_di
          EXTERN      bit_close
          EXTERN      bit_close_ei


;Sound routine..enter in with e holding the desired effect!


.bit_fx
._bit_fx
          pop  bc
          pop  de
          push de
          push bc

        IF sndbit_port >= 256
          exx
          ld   bc,sndbit_port
          exx
        ENDIF

          ld    a,e  
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
          
.table    defw    fx2           ; effect #0
          defw    fx5
          defw    fx6
          defw    zap0
          defw    zap1
          defw    clackson
          defw    zap3
          defw    warpcall      ; effect #7
          
          
;Strange squeak hl=300,de=2
;Game up hl=300,de=10 inc de
;-like a PACMAN sound
.fx6      ld    b,1  
.fx6_1    push  bc  
          ld    hl,300  
          ld    de,10  
.fx6_2    push  hl
          push  de
          call  beeper  
          pop   de
          pop   hl
;      inc  de           ;if added in makes different sound..
          ld    bc,10
          and   a
          sbc   hl,bc
          jr    nc,fx6_2
          pop   bc
          djnz  fx6_1
          ret 
          
          
;Use during key defines?
          
.fx2      call  bit_open_di
          ld    e,150  
.fx2_1
        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

          xor   sndbit_mask  
          ld    b,e  
.fx2_2    djnz  fx2_2  
          inc   e  
          jr    nz,fx2_1  
          call    bit_close_ei
          ret
          
          
;Laser repeat sound
.fx5      ld    b,1  
.fx5_1    push  bc  
          ld    hl,1200  
          ld    de,6  
.fx5_2    push  hl  
          push  de  
          call  beeper  
          pop   de  
          pop   hl  
          ld    bc,100  
          and   a  
          sbc   hl,bc  
          jr    nc,fx5_2  
          pop   bc  
          djnz  fx5_1  
          ret   
          
          
;Eating sound

.zap0     call  bit_open_di
          ld    h,4
.zap0_1   ld    b,(hl)  
          dec   hl  
.zap0_2   djnz  zap0_2  

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

          xor   sndbit_mask
          ex    af,af
          ld    a,h  
          or    l
          jr    z,zap0_3
          ex    af,af
          jr    zap0_1  
.zap0_3   call    bit_close_ei
          ret

          
;Clackson sound
          
.clackson
          call  bit_open_di
.clackson_LENGHT
          ld      b,90
        IF sndbit_port <= 255
          ld      c,sndbit_port
        ENDIF
.clackson_loop
          dec     h
          jr      nz,clackson_jump
          xor     sndbit_mask

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;8 T slower
          exx
        ELSE
          out  (c),a
        ENDIF

.clackson_FR_1
          ld      h,230
.clackson_jump
          dec     l
          jr      nz,clackson_loop
          xor     sndbit_mask

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;8 T slower
          exx
        ELSE
          out  (c),a
        ENDIF

.clackson_FR_2
          ld      l,255
          djnz    clackson_loop
          call  bit_close_ei
          ret
          
          
;Beep thing
          
.zap3     call  bit_open_di
.zap3_1   push  bc
          xor   sndbit_mask

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

          push  af
          xor   a
          sub   b
          ld    b,a
          pop   af
.zap3_2   nop
          djnz  zap3_2
          xor   sndbit_mask

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

          pop   bc
          push  bc
.zap3_3   nop
          djnz  zap3_3
          pop   bc
          djnz  zap3_1
          call    bit_close_ei
          ret
          
          
;Sound for warp
          
.warpcall
          ld    hl,1600  
          ld    (warps+1),hl  
          ld    hl,-800  
          ld    (warps1+1),hl  
          ld    hl,-100  
          ld    (warps2+1),hl  
          ld   b,20
.warpcall1
          push bc
          call warps
          pop  bc
          djnz warpcall1
          ret   
          
.warps    ld    hl,1600  
          ld    de,6  
          call  beeper  
.warps1   ld    hl,-800  
.warps2   ld    de,-100  
          and   a  
          sbc   hl,de  
          ld    (warps1+1),hl  
          jr    nz,warps3  
          ld    de,100  
          ld    (warps2+1),de  
.warps3   ex    de,hl  
          ld    hl,1600  
          add   hl,de  
          ld    (warps+1),hl  
          ret   
          
          
;Our old squelch...

.zap1     call  bit_open
          ld    b,0  
.zap1_1   push  bc  
          xor   sndbit_mask  ;oscillate between high and low bits...

        IF sndbit_port >= 256
          exx
          out  (c),a                   ;9 T slower
          exx
        ELSE
          out  (sndbit_port),a
        ENDIF

.zap1_2   nop
          nop
          djnz  zap1_2
          pop   bc
          djnz  zap1_1
          jp    bit_close
          
          
