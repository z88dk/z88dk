
; void bit_beepfx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx

EXTERN asm_bit_beepfx

_bit_beepfx:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_bit_beepfx
