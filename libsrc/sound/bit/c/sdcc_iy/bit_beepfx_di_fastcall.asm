
; void bit_beepfx_di_fastcall(void *effect)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beepfx_di_fastcall

EXTERN asm_bit_beepfx_di

_bit_beepfx_di_fastcall:

   push hl
   pop ix
   
   jp asm_bit_beepfx_di
