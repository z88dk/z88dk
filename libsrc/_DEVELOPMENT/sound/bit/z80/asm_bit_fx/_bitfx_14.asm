
XLIB _bitfx_14

INCLUDE "clib_target_cfg.asm"

LIB asm_bit_open

_bitfx_14:

   ; Squoink

   ld a,230
   ld (qi_FR_1 + 1),a
   
   xor a
   ld (qi_FR_2 + 1),a
   
   call asm_bit_open
   ld b,200

qi_loop:

   dec h
   jr nz, qi_jump
   
   push af
   
   ld a,(qi_FR_1 + 1)
   dec a
   ld (qi_FR_1 + 1),a
   
   pop af
   xor __sound_bit_toggle
   
   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

qi_FR_1:

   ld h,50

qi_jump:

   inc l
   jr nz, qi_loop
   
   push af
   
   ld a,(qi_FR_2 + 1)
   inc a
   ld (qi_FR_2 + 1),a
   
   pop af
   xor __sound_bit_toggle

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

qi_FR_2:

   ld l,0
   djnz qi_loop
   
   ret
