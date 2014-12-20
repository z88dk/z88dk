
; void bit_beepfx_di(void *effect)

SECTION code_sound_bit

PUBLIC _bit_beepfx_di

_bit_beepfx_di:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_bit_beepfx_di
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_beepfx_di.asm"
