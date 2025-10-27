
SECTION smc_clib
SECTION smc_sound_bit

PUBLIC _bitfx_7

INCLUDE "config_private.inc"

EXTERN asm_bit_beep_raw

_bitfx_7:

   ; sound for warp

   ld hl,1600
   ld (warps + 1),hl
   
   ld hl,-800
   ld (warps1 + 1),hl
   
   ld hl,-100
   ld (warps2 + 1),hl
   
   ld b,20

warpcall1:

   push bc
   call warps
   pop bc
   
   djnz warpcall1
   
   scf
   ret

warps:

   ld hl,1600
   ld de,6

   call asm_bit_beep_raw

warps1:

   ld hl,-800

warps2:

   ld de,-100
   
   or a
   sbc hl,de
   
   ld (warps1 + 1),hl
   jr nz, warps3
   
   ld de,100
   ld (warps2 + 1),de

warps3:

   ex de,hl
   
   ld hl,1600
   add hl,de
   
   ld (warps + 1),hl
   
   scf
   ret
