
; void bit_beepfx(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_beepfx

EXTERN asm_bit_beepfx

bit_beepfx:

   push hl
   pop ix
   
   jp asm_bit_beepfx
