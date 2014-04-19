
XLIB _bitfx_3

INCLUDE "clib_target_cfg.asm"

_bitfx_3:

   ; Eating sound
   
   ld h,4

zap0_1:

   ld b,(hl)
   dec hl

zap0_2:

   djnz zap0_2

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   xor __sound_bit_toggle
   
   ld c,a
   
   ld a,h
   or l
   ret z
   
   ld a,c
   jr zap0_1
