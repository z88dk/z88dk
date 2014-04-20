
XLIB _bitfx_4

INCLUDE "clib_target_cfg.asm"

_bitfx_4:

   ; Our old squelch...
   
   ld b,0

zap1_1:

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

zap1_2:

   nop
   nop
   
   djnz zap1_2   

   pop bc
   djnz zap1_1
   
   ret
