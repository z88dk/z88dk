
; void bit_beepfx(void *effect)

SECTION code_sound_bit

PUBLIC _bit_beepfx

_bit_beepfx:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_bit_beepfx
   
   pop ix
   ret

   INCLUDE "sound/bit/z80/asm_bit_beepfx.asm"
