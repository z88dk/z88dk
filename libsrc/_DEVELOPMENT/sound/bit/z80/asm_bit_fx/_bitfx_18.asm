
XLIB _bitfx_18

INCLUDE "clib_target_cfg.asm"

_bitfx_18:

   ; steam engine

   ld hl,0

coff2:

   push af
   
   xor __sound_bit_toggle
   and (hl)
   ld b,a
   
   pop af
   xor b

   IF __sound_bit_method = 1
   
      out (__sound_bit_port),a
   
   ELSE IF __sound_bit_method = 2
   
      exx
      out (c),a
      exx
   
   ELSE IF __sound_bit_method = 3
   
      ld (__sound_bit_port),a
   
   ENDIF

   ld b,(hl)

cdly:

   djnz cdly
   
   inc hl
   
   bit 7,l
   jr z, coff2
   
   ret
