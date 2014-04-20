
XLIB _bitfx_6

INCLUDE "clib_target_cfg.asm"

_bitfx_6:

   ; beep thing

zap3_1:

   push bc
   
   xor __sound_bit_toggle

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   push af
   
   xor a
   sub b
   ld b,a
   
   pop af

zap3_2:

   nop
   djnz zap3_2
   
   xor __sound_bit_toggle
   
   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ENDIF
   
   IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   pop bc
   push bc

zap3_3:

   nop
   djnz zap3_3
   
   pop bc
   djnz zap3_1
   
   ret
