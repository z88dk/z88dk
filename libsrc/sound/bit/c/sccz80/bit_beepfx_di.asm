
; void bit_beepfx_di(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_beepfx_di

EXTERN asm_bit_beepfx_di

bit_beepfx_di:

   push hl
   pop ix
   
   jp asm_bit_beepfx_di
