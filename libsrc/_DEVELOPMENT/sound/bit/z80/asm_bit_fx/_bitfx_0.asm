
XLIB _bitfx_0

INCLUDE "clib_target_cfg.asm"

_bitfx_0:
      
   ld e,150

fx2_1:

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

   xor __sound_bit_toggle
   
   ld b,e

fx2_2:

   djnz fx2_2
   
   inc e
   jr nz, fx2_1
   
   ret
