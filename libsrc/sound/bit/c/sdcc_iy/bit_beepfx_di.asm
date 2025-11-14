
; void bit_beepfx_di(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_di

EXTERN asm_bit_beepfx_di

_bit_beepfx_di:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_bit_beepfx_di
