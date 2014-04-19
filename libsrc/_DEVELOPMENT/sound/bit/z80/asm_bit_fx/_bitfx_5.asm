
XLIB _bitfx_5

INCLUDE "clib_target_cfg.asm"

_bitfx_5:
   
   ; klaxon sound

   ld b,90

klaxon_loop:

   dec h
   jr nz, klaxon_jump
   
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

klaxon_FR_1:

   ld h,230

klaxon_jump:

   dec l
   jr nz, klaxon_loop
   
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

klaxon_FR_2:

   ld l,255
   djnz klaxon_loop
   
   ret
